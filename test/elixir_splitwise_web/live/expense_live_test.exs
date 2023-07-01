defmodule ElixirSplitwiseWeb.ExpenseLiveTest do
  use ElixirSplitwiseWeb.ConnCase

  import Phoenix.LiveViewTest
  import ElixirSplitwise.ExpensesFixtures

  @create_attrs %{amount: 120.5, created_by: 42, currency: "some currency", description: "some description", id: 42, notes: "some notes", paid_by: %{}, shared_with_friend: 42, shared_with_group: 42, split_option: "some split_option"}
  @update_attrs %{amount: 456.7, created_by: 43, currency: "some updated currency", description: "some updated description", id: 43, notes: "some updated notes", paid_by: %{}, shared_with_friend: 43, shared_with_group: 43, split_option: "some updated split_option"}
  @invalid_attrs %{amount: nil, created_by: nil, currency: nil, description: nil, id: nil, notes: nil, paid_by: nil, shared_with_friend: nil, shared_with_group: nil, split_option: nil}

  defp create_expense(_) do
    expense = expense_fixture()
    %{expense: expense}
  end

  describe "Index" do
    setup [:create_expense]

    test "lists all expenses", %{conn: conn, expense: expense} do
      {:ok, _index_live, html} = live(conn, ~p"/expenses")

      assert html =~ "Listing Expenses"
      assert html =~ expense.currency
    end

    test "saves new expense", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/expenses")

      assert index_live |> element("a", "New Expense") |> render_click() =~
               "New Expense"

      assert_patch(index_live, ~p"/expenses/new")

      assert index_live
             |> form("#expense-form", expense: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#expense-form", expense: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/expenses")

      html = render(index_live)
      assert html =~ "Expense created successfully"
      assert html =~ "some currency"
    end

    test "updates expense in listing", %{conn: conn, expense: expense} do
      {:ok, index_live, _html} = live(conn, ~p"/expenses")

      assert index_live |> element("#expenses-#{expense.id} a", "Edit") |> render_click() =~
               "Edit Expense"

      assert_patch(index_live, ~p"/expenses/#{expense}/edit")

      assert index_live
             |> form("#expense-form", expense: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#expense-form", expense: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/expenses")

      html = render(index_live)
      assert html =~ "Expense updated successfully"
      assert html =~ "some updated currency"
    end

    test "deletes expense in listing", %{conn: conn, expense: expense} do
      {:ok, index_live, _html} = live(conn, ~p"/expenses")

      assert index_live |> element("#expenses-#{expense.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#expenses-#{expense.id}")
    end
  end

  describe "Show" do
    setup [:create_expense]

    test "displays expense", %{conn: conn, expense: expense} do
      {:ok, _show_live, html} = live(conn, ~p"/expenses/#{expense}")

      assert html =~ "Show Expense"
      assert html =~ expense.currency
    end

    test "updates expense within modal", %{conn: conn, expense: expense} do
      {:ok, show_live, _html} = live(conn, ~p"/expenses/#{expense}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Expense"

      assert_patch(show_live, ~p"/expenses/#{expense}/show/edit")

      assert show_live
             |> form("#expense-form", expense: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#expense-form", expense: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/expenses/#{expense}")

      html = render(show_live)
      assert html =~ "Expense updated successfully"
      assert html =~ "some updated currency"
    end
  end
end
