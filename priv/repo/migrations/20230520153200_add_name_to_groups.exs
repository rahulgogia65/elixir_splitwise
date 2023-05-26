defmodule ElixirSplitwise.Repo.Migrations.AddNameToGroups do
  use Ecto.Migration

  def change do
    alter table(:groups) do
      add :name, :string
    end
  end
end
