defmodule ElixirSplitwise.Accounts.Friendship do
  use Ecto.Schema
  import Ecto.Changeset
  alias ElixirSplitwise.Repo
  alias ElixirSplitwise.Accounts.User
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
end
