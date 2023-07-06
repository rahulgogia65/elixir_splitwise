defmodule ElixirSplitwiseWeb.FriendshipLive do
  use ElixirSplitwiseWeb, :live_view
  alias ElixirSplitwise.Accounts.Friendship

  alias ElixirSplitwise.Expenses.Expense

  @impl true
  def mount(params, _session, socket) do
    current_user = socket.assigns.current_user
    friendship_id = params["id"]

    if friendship_id && Friendship.is_user_in_friendship?(current_user, friendship_id) do
      {:ok, assign(socket, friendship_id: friendship_id)}
    else
      case friendship_id do
        nil ->
          {:ok, socket |> put_flash(:error, "Action not allowed") |> redirect(to: "/dashboard")}

        _ ->
          {:ok, socket |> put_flash(:error, "Friend not found") |> redirect(to: "/dashboard")}
      end
    end
  end

  def friend_name(current_user, friendship_id) do
    Friendship.get_friend_name(current_user, friendship_id)
  end

  @impl true
  def handle_params(params, url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params, url)}
  end

  defp apply_action(socket, :add_expense, _params, _url) do
    socket
    |> assign(:page_title, "New Expense")
    |> assign(:expense, %Expense{})
  end

  defp apply_action(socket, nil, _params, url) do
    socket
    |> assign(:url, URI.parse(url))
  end
end
