defmodule ElixirSplitwise.Repo.Migrations.CreateGroupMembers do
  use Ecto.Migration

  def change do
    create table("group_members", primary_key: false) do
      add :group_id, references(:groups)
      add :member_id, references(:users)
    end
  end
end
