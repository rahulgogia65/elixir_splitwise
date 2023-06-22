defmodule ElixirSplitwise.Accounts.Friendship do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias ElixirSplitwise.Repo
  alias ElixirSplitwise.Accounts.{User, Friendship}
  schema "friendships" do

    field :user1_id, :id
    field :user2_id, :id

    timestamps()
  end

  @doc false
  def changeset(friendship, attrs) do
    friendship
    |> cast(attrs, [:user1_id, :user2_id])
    |> validate_user_existence()
    |> validate_different_users()
    |> valdate_unique_friendship()
  end

  defp validate_user_existence(changeset) do
    user1_id = get_change(changeset, :user1_id)
    user2_id = get_change(changeset, :user2_id)

    changeset
    |> add_user_existence_error(:user1_id, user1_id)
    |> add_user_existence_error(:user2_id, user2_id)
  end

  defp add_user_existence_error(changeset, field, user_id) do
    if !check_user_existence(user_id) do
      changeset
      |> add_error(field, "User with ID #{user_id} does not exist")
    else
      changeset
    end
  end

  defp check_user_existence(id) do
    Repo.get(User, id) != nil
  end

  defp validate_different_users(changeset) do
    user1_id = get_change(changeset, :user1_id)
    user2_id = get_change(changeset, :user2_id)

    if user1_id != user2_id do
      changeset
    else
      changeset
      |> add_error(:user2_id, "You cannot add yourself as a friend")
    end
  end

  defp valdate_unique_friendship(changeset) do
    user1_id = get_change(changeset, :user1_id)
    user2_id = get_change(changeset, :user2_id)

    query = from f in Friendship,
      where: (
        (f.user1_id == ^user1_id and f.user2_id == ^user2_id) or
        (f.user2_id == ^user1_id and f.user1_id == ^user2_id)
      )

    if Repo.exists?(query) do
      changeset
      |> add_error(:id, "Friendship Alreay exists")
    else
      changeset
    end
  end

  def get_friends_id_list_for(user_id) do
    query = from f in Friendship,
    where: f.user1_id == ^user_id or f.user2_id == ^user_id,
    select: {f.user1_id, f.user2_id}

    friend_ids = Repo.all(query)
    |> Enum.flat_map(fn {user1_id, user2_id} ->
      case user1_id do
        ^user_id -> [user2_id]
        _ -> [user1_id]
      end
    end)
    |> Enum.uniq()
  end

  def get_friend_names(friend_ids) do
    query = from u in User,
      where: u.id in ^friend_ids,
      select: u.name

    Repo.all(query)
  end

  def get_friend_name(current_user, id) do
    friendship = Repo.get(Friendship, id)

    friend_id =
      if current_user.id == friendship.user1_id do
        friendship.user2_id
      else
        friendship.user1_id
      end

    friend = Repo.get(User, friend_id)
    friend.name
  end
end
