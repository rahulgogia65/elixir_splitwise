defmodule ElixirSplitwise.Repo.Migrations.CreateExpenses do
  use Ecto.Migration

  def change do
    create table(:expenses) do
      add(:shared_with_friend, references(:users, on_delete: :delete_all))
      add(:description, :string)
      add(:currency, :string)
      add(:amount, :float)
      add(:created_by, references(:users, on_delete: :delete_all))
      add(:paid_by, :map)
      add(:split_option, :string)
      add(:notes, :string)

      timestamps()
    end
  end
end
