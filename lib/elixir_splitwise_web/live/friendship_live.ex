defmodule ElixirSplitwiseWeb.Live.FriendshipLive do
  use ElixirSplitwiseWeb, :live_view
  alias ElixirSplitwise.Accounts.Friendship

  def mount(params, _session, socket) do
    current_user = socket.assigns.current_user
    friendship_id = params["id"]

    if Friendship.is_user_in_friendship?(current_user, friendship_id) do
      {:ok, assign(socket, friendship_id: friendship_id)}
    else
      {:ok, socket |> put_flash(:error, "Friend not found") |> redirect(to: "/dashboard")}
    end
  end

  def friend_name(current_user, friendship_id) do
    Friendship.get_friend_name(current_user, friendship_id)
  end
end
