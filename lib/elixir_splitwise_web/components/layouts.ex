defmodule ElixirSplitwiseWeb.Layouts do
  use ElixirSplitwiseWeb, :html
  alias ElixirSplitwise.Accounts.Friendship

  embed_templates "layouts/*"

  def friends_list(user) do
    friends_id_list = Friendship.get_friends_id_list_for(user.id)
    Friendship.get_friend_names(friends_id_list) |> Enum.reject(&is_nil/1)
  end
end
