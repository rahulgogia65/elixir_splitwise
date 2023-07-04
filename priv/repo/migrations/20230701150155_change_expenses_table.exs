defmodule ElixirSplitwise.Repo.Migrations.ChangeExpensesTable do
  use Ecto.Migration

  def change do
   rename(table(:expenses), :created_by, to: :created_by_id)
   rename(table(:expenses), :shared_with_friend, to: :shared_with_friend_id)
  end
end
