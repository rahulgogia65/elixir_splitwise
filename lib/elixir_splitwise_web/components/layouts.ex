defmodule ElixirSplitwiseWeb.Layouts do
  use ElixirSplitwiseWeb, :html
  alias ElixirSplitwise.Accounts.Friendship

  embed_templates "layouts/*"

  def friends_list(user) do
    Friendship.get_friends_list(user.id)
    # [{"Amit", "/friends/15"}]
  end
end
