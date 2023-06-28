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

  def validate_different_users(changeset) do
    user1 = get_change(changeset, :user1)
    user2 = get_change(changeset, :user2)

    if user1 != user2 do
      changeset
    else
      changeset
      |> add_error(:user2, "You cannot add yourself as a friend")
    end
  end

  def valdate_unique_friendship(changeset) do
    user1 = get_change(changeset, :user1)
    user2 = get_change(changeset, :user2)

    sent_friendships_to_user2_exists =
      user1.data
      |> Ecto.assoc(:sent_friendships)
      |> where([sf], sf.user2_id == ^user2.data.id)
      |> Repo.exists?()

    recieved_friendships_from_user2_exists =
      user1.data
      |> Ecto.assoc(:received_friendships)
      |> where([rf], rf.user1_id == ^user2.data.id)
      |> Repo.exists?()

    unless sent_friendships_to_user2_exists or recieved_friendships_from_user2_exists do
      changeset
    else
      changeset
      |> add_error(:id, "Friendship Alreay exists")
    end
  end

  # def get_friends_id_list_for(user_id) do
  #   query =
  #     from f in Friendship,
  #       where: f.user1_id == ^user_id or f.user2_id == ^user_id,
  #       select: {f.id, f.user1_id, f.user2_id}

  #   Repo.all(query)
  #   |> Enum.flat_map(fn {id, user1_id, user2_id} ->
  #     case user1_id do
  #       ^user_id -> [{id, user2_id}]
  #       _ -> [{id, user1_id}]
  #     end
  #   end)
  #   |> Enum.uniq()
  # end

  # def get_friend_names(friend_ids) do
  #   query =
  #     from u in User,
  #       where: u.id in ^friend_ids,
  #       select: u.name

  #   Repo.all(query)
  # end

  def get_friend_name(current_user, id) do
    friendship = Repo.get(Friendship, id) |> Repo.preload([:user1, :user2])

    case friendship.user1 do
      current_user ->
        friendship.user2.name

      %User{name: name} ->
        name
    end
  end

  def is_user_in_friendship?(current_user, friendship_id) do
    case Repo.get(Friendship, friendship_id) |> Repo.preload([:user1, :user2]) do
      %Friendship{user1: user1, user2: user2} ->
        (current_user == user1) or (current_user == user2)
      _ ->
        false
    end
  end

  def get_friends_list(user) do
    user = user |> Repo.preload([:sent_friendships, :received_friendships])

    sent_friendships = user
                       |> Ecto.assoc(:sent_friendships)
                       |> Ecto.Query.join(:inner, [f], u in assoc(f, :user2))
                       |> Ecto.Query.select([f, u], {u.name, f.id})
                       |> Repo.all()

    received_friendships = user
                           |> Ecto.assoc(:received_friendships)
                           |> Ecto.Query.join(:inner, [f], u in assoc(f, :user1))
                           |> Ecto.Query.select([f, u], {u.name, f.id})
                           |> Repo.all()

    sent_friendships ++ received_friendships
  end
end
