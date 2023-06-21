defmodule ElixirSplitwiseWeb.Layouts do
  use ElixirSplitwiseWeb, :html
  alias ElixirSplitwise.Accounts.Friendship

  embed_templates "layouts/*"

  def friends_list(user) do
    Friendship.get_friend_list_for(user.id)
  end
end
