defmodule ElixirSplitwise.Expenses.Expense do
  use Ecto.Schema
  import Ecto.Changeset

  alias ElixirSplitwise.Accounts.Friendship
  alias ElixirSplitwise.Accounts.User

  schema "expenses" do
    field :amount, :float
    field :currency, :string
    field :description, :string
    field :notes, :string
    field :paid_by, :integer
    field :split_option, :string

    belongs_to :created_by, User, foreign_key: :created_by_id
    belongs_to :shared_with_friend, Friendship, foreign_key: :shared_with_friend_id

    timestamps()
  end

  @doc false
  def changeset(expense, attrs) do
    expense
    |> cast(attrs, [:description, :amount, :paid_by, :split_option, :notes])
    |> validate_required([:description, :amount, :paid_by])
  end
end
