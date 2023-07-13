defmodule ElixirSplitwiseWeb.ExpenseLive.Modals.AddExpense do
  use ElixirSplitwiseWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
