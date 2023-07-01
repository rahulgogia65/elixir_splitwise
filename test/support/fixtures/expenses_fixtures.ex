defmodule ElixirSplitwise.ExpensesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ElixirSplitwise.Expenses` context.
  """

  @doc """
  Generate a expense.
  """
  def expense_fixture(attrs \\ %{}) do
    {:ok, expense} =
      attrs
      |> Enum.into(%{
        amount: 120.5,
        created_by: 42,
        currency: "some currency",
        description: "some description",
        id: 42,
        notes: "some notes",
        paid_by: %{},
        shared_with_friend: 42,
        shared_with_group: 42,
        split_option: "some split_option"
      })
      |> ElixirSplitwise.Expenses.create_expense()

    expense
  end
end
