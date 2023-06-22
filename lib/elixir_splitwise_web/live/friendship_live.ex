defmodule ElixirSplitwiseWeb.Live.FriendshipLive do
  use ElixirSplitwiseWeb, :live_view
  alias ElixirSplitwise.Accounts.Friendship

  def mount(params, _session, socket) do
    
    {:ok, assign(socket, friendship_id: params["id"])}
  end

  def friend_name(current_user, friendship_id) do
    friendship = Friendship.get_friend_name(current_user, friendship_id)
  end
end
