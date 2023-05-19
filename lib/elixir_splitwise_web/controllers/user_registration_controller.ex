defmodule ElixirSplitwiseWeb.UserRegistrationController do
  use ElixirSplitwiseWeb, :controller

  alias ElixirSplitwise.Accounts
  alias ElixirSplitwise.Accounts.User
  alias ElixirSplitwiseWeb.UserAuth

  plug :get_user_by_register_token when action in [:edit, :update]

  def new(conn, _params) do
    changeset = Accounts.change_user_registration(%User{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &url(~p"/users/confirm/#{&1}")
          )

        conn
        |> put_flash(:info, "User created successfully.")
        |> UserAuth.log_in_user(user)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def edit(conn, _params) do
    render(conn, :edit, changeset: Accounts.add_user(conn.assigns.user))
  end

  def update(conn, %{"user" => user_params}) do
    case Accounts.add_friend_user(conn.assigns.user, user_params) do
      {:ok, user} ->
        {:ok, _} =
        Accounts.deliver_user_confirmation_instructions(
            user,
            &url(~p"/users/confirm/#{&1}")
          )

        conn
        |> put_flash(:info, "User created successfully.")
        |> UserAuth.log_in_user(user)

      {:error, changeset} ->
        render(conn, :edit, changeset: changeset)
    end
  end

  defp get_user_by_register_token(conn, _opts) do
    %{"token" => token} = conn.params

    if user = Accounts.get_user_by_register_token(token) do
      conn |> assign(:user, user) |> assign(:token, token)
    else
      conn
      |> put_flash(:error, "Token has expired")
      |> redirect(to: ~p"/")
      |> halt()
    end
  end
end
