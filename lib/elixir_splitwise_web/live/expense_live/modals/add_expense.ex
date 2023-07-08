defmodule ElixirSplitwiseWeb.ExpenseLive.Modals.AddExpense do
  use ElixirSplitwiseWeb, :live_view

  alias ElixirSplitwise.Expenses.Expense

  @impl true
  def mount(_params, _session, socket) do
    IO.inspect(socket, label: "..................Expense socket")
    {:ok, socket}
  end
end
