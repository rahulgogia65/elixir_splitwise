defmodule ElixirSplitwise.ExpensesTest do
  use ElixirSplitwise.DataCase

  alias ElixirSplitwise.Expenses

  describe "expenses" do
    alias ElixirSplitwise.Expenses.Expense

    import ElixirSplitwise.ExpensesFixtures

    @invalid_attrs %{amount: nil, created_by: nil, currency: nil, description: nil, id: nil, notes: nil, paid_by: nil, shared_with_friend: nil, shared_with_group: nil, split_option: nil}

    test "list_expenses/0 returns all expenses" do
      expense = expense_fixture()
      assert Expenses.list_expenses() == [expense]
    end

    test "get_expense!/1 returns the expense with given id" do
      expense = expense_fixture()
      assert Expenses.get_expense!(expense.id) == expense
    end

    test "create_expense/1 with valid data creates a expense" do
      valid_attrs = %{amount: 120.5, created_by: 42, currency: "some currency", description: "some description", id: 42, notes: "some notes", paid_by: %{}, shared_with_friend: 42, shared_with_group: 42, split_option: "some split_option"}

      assert {:ok, %Expense{} = expense} = Expenses.create_expense(valid_attrs)
      assert expense.amount == 120.5
      assert expense.created_by == 42
      assert expense.currency == "some currency"
      assert expense.description == "some description"
      assert expense.id == 42
      assert expense.notes == "some notes"
      assert expense.paid_by == %{}
      assert expense.shared_with_friend == 42
      assert expense.shared_with_group == 42
      assert expense.split_option == "some split_option"
    end

    test "create_expense/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Expenses.create_expense(@invalid_attrs)
    end

    test "update_expense/2 with valid data updates the expense" do
      expense = expense_fixture()
      update_attrs = %{amount: 456.7, created_by: 43, currency: "some updated currency", description: "some updated description", id: 43, notes: "some updated notes", paid_by: %{}, shared_with_friend: 43, shared_with_group: 43, split_option: "some updated split_option"}

      assert {:ok, %Expense{} = expense} = Expenses.update_expense(expense, update_attrs)
      assert expense.amount == 456.7
      assert expense.created_by == 43
      assert expense.currency == "some updated currency"
      assert expense.description == "some updated description"
      assert expense.id == 43
      assert expense.notes == "some updated notes"
      assert expense.paid_by == %{}
      assert expense.shared_with_friend == 43
      assert expense.shared_with_group == 43
      assert expense.split_option == "some updated split_option"
    end

    test "update_expense/2 with invalid data returns error changeset" do
      expense = expense_fixture()
      assert {:error, %Ecto.Changeset{}} = Expenses.update_expense(expense, @invalid_attrs)
      assert expense == Expenses.get_expense!(expense.id)
    end

    test "delete_expense/1 deletes the expense" do
      expense = expense_fixture()
      assert {:ok, %Expense{}} = Expenses.delete_expense(expense)
      assert_raise Ecto.NoResultsError, fn -> Expenses.get_expense!(expense.id) end
    end

    test "change_expense/1 returns a expense changeset" do
      expense = expense_fixture()
      assert %Ecto.Changeset{} = Expenses.change_expense(expense)
    end
  end
end
