defmodule ElixirSplitwise.Repo.Migrations.CreateFriendships do
  use Ecto.Migration

  def change do
    create table(:friendships) do
      add :user1_id, references(:users, on_delete: :nothing)
      add :user2_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:friendships, [:user1_id])
    create index(:friendships, [:user2_id])
  end
end
