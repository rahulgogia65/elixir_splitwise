defmodule ElixirSplitwiseWeb.ExpenseLive.New do
  use ElixirSplitwiseWeb, :live_view

  # alias ElixirSplitwise.Expenses
  alias ElixirSplitwise.Expenses.Expense

  @impl true
  def mount(_params, _session, socket) do
    IO.inspect socket, label: "......................Socket"
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Expense")
    |> assign(:expense, %Expense{})
  end
end
