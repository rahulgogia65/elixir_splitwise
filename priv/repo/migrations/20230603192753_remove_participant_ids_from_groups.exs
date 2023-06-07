defmodule ElixirSplitwise.Repo.Migrations.RemoveParticipantIdsFromGroups do
  use Ecto.Migration

  def change do
    alter table(:groups) do
      remove(:participant_ids)
    end
  end
end
