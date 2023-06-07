defmodule ElixirSplitwise.Accounts.Group do
  use Ecto.Schema
  import Ecto.Changeset

  schema "groups" do
    field :invite_link, :string
    field :participant_ids, {:array, :integer}
    field :simplify_group_debts, :boolean, default: false
    field :type, :string
    field :name, :string

    many_to_many :users, ElixirSplitwise.Accounts.User,
      join_through: "group_members"

    timestamps()
  end

  @doc false
  def changeset(group, attrs) do
    group
    |> cast(attrs, [:type, :participant_ids, :invite_link, :simplify_group_debts, :name])
    |> validate_required([:type, :participant_ids, :invite_link, :simplify_group_debts, :name])
  end
end
