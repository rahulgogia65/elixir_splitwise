defmodule ElixirSplitwise.Expenses.Expense do
  use Ecto.Schema
  import Ecto.Changeset

  alias ElixirSplitwise.Accounts.User

  schema "expenses" do
    field :amount, :float
    field :currency, :string
    field :description, :string
    field :notes, :string
    field :paid_by, :map
    field :split_option, :string

    belongs_to :created_by, User
    belongs_to :shared_with_friend, User

    timestamps()
  end

  @doc false
  def changeset(expense, attrs) do
    expense
    |> cast(attrs, [:id, :shared_with_friend, :shared_with_group, :description, :currency, :amount, :created_by, :paid_by, :split_option, :notes])
    |> validate_required([:id, :shared_with_friend, :shared_with_group, :description, :currency, :amount, :created_by, :paid_by, :split_option, :notes])
  end
end
