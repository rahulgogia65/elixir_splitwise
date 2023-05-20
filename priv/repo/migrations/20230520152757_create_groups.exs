defmodule ElixirSplitwise.Repo.Migrations.CreateGroups do
  use Ecto.Migration

  def change do
    create table(:groups) do
      add :type, :string
      add :participant_ids, {:array, :integer}
      add :invite_link, :string
      add :simplify_group_debts, :boolean, default: false, null: false

      timestamps()
    end
  end
end
