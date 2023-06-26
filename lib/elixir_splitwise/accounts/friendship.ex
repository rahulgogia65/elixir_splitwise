defmodule ElixirSplitwise.Accounts.Friendship do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias ElixirSplitwise.Repo
  alias ElixirSplitwise.Accounts.{User, Friendship}

  schema "friendships" do
    belongs_to(:user1, User, foreign_key: :user1_id)
    belongs_to(:user2, User, foreign_key: :user2_id)

    timestamps()
  end

  @doc false
  def changeset(friendship, attrs \\ %{}) do
    friendship
    |> cast(attrs, [])
  end

  def validate_user_existence(changeset) do
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

  def validate_different_users(changeset) do
    user1_id = get_change(changeset, :user1_id)
    user2_id = get_change(changeset, :user2_id)

    if user1_id != user2_id do
      changeset
    else
      changeset
      |> add_error(:user2_id, "You cannot add yourself as a friend")
    end
  end

  def valdate_unique_friendship(changeset) do
    user1_id = get_change(changeset, :user1_id)
    user2_id = get_change(changeset, :user2_id)

    query =
      from f in Friendship,
        where:
          (f.user1_id == ^user1_id and f.user2_id == ^user2_id) or
            (f.user2_id == ^user1_id and f.user1_id == ^user2_id)

    if Repo.exists?(query) do
      changeset
      |> add_error(:id, "Friendship Alreay exists")
    else
      changeset
    end
  end

  def get_friends_id_list_for(user_id) do
    query =
      from f in Friendship,
        where: f.user1_id == ^user_id or f.user2_id == ^user_id,
        select: {f.id, f.user1_id, f.user2_id}

    Repo.all(query)
    |> Enum.flat_map(fn {id, user1_id, user2_id} ->
      case user1_id do
        ^user_id -> [{id, user2_id}]
        _ -> [{id, user1_id}]
      end
    end)
    |> Enum.uniq()
  end

  def get_friend_names(friend_ids) do
    query =
      from u in User,
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

  def is_user_in_friendship?(user_id, friendship_id) do
    case Repo.get(Friendship, friendship_id) do
      %Friendship{user1_id: user1_id, user2_id: user2_id} ->
        user_id in [user1_id, user2_id]
      _ ->
        false
    end
  end

  def get_friends_list(user_id) do
    user = Repo.get(User, user_id) |> Repo.preload([:sent_friendships, :received_friendships])
    query =
      from f in Friendship,
        join: u1 in User, on: f.user1_id == u1.id,
        join: u2 in User, on: f.user2_id == u2.id,
        where: ^user_id in [f.user1_id, f.user2_id],
        select: {f.id, ^user_id == f.user1_id, u1.name, u2.name}

    Repo.all(query)
    |> Enum.map(fn {id, is_user1, name1, name2} ->
      {(if is_user1, do: name2, else: name1), id}
    end)
  end
end
