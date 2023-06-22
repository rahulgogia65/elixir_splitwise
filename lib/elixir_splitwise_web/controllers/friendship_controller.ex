defmodule ElixirSplitwiseWeb.FriendshipController do
  use ElixirSplitwiseWeb, :controller

  alias ElixirSplitwise.Accounts

  def new(conn, _params) do
    render(conn, :new)
  end

  def create(%Plug.Conn{assigns: %{current_user: current_user}} = conn, %{"email" => email}) do
    Accounts.add_friend(email, current_user)
    redirect(conn, to: "/")
  end

  def show(conn, params) do
    
  end
end
