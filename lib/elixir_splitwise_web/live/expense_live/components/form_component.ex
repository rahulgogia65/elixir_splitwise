defmodule ElixirSplitwiseWeb.ExpenseLive.Components.FormComponent do
  use ElixirSplitwiseWeb, :live_component

  alias ElixirSplitwise.Expenses

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header class="-mb-8">
        <%= @title %>
      </.header>

      <.simple_form
        for={@form}
        id="expense-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <span>With you and <%= @friend.name %></span>
        <.input field={@form[:description]} type="text" label="Description" />
        <.input field={@form[:amount]} type="number" label="Amount" step="any" />
        <.input field={@form[:notes]} type="text" label="Notes" />
        Paid by <.input field={@form[:paid_by]} type="select" options={["#{@current_user.name}": @current_user.id, "#{@friend.name}": @friend.id]}/>
        and split by
        <.button phx-click={show_modal("split_option")}>
          <%= @split_option %>
        </.button>
        <:actions>
          <.button phx-disable-with="Saving...">Save Expense</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{expense: expense} = assigns, socket) do
    changeset = Expenses.change_expense(expense)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"expense" => expense_params}, socket) do
    # expense_params = %{expense_params | "paid_by" => %{"#{expense_params["paid_by"]}": expense_params["amount"]}}

    changeset =
      socket.assigns.expense
      |> Expenses.change_expense(expense_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"expense" => expense_params}, socket) do
    updated_params =
      expense_params
      |> Map.put("shared_with_friend_id", socket.assigns.friendship_id)
      |> Map.put("created_by_id", socket.assigns.current_user.id)
      |> Map.update!("paid_by", &String.to_integer/1)

    # expense_params =
    #   expense_params
    #   |> Map.put("shared_with_friend_id", socket.assigns.friend.id)
    #   |> Map.put("created_by_id", socket.assigns.current_user.id)

    # expense_params = %{
    #   expense_params
    #   | "paid_by" => Integer.parse(expense_params["paid_by"]) |> elem(0)
    # }

    # save_expense(socket, socket.assigns.action, expense_params)
    IO.inspect(updated_params, label: ".....................Updated params")
    save_expense(socket, updated_params)
  end

  # defp save_expense(socket, :edit, expense_params) do
  #   case Expenses.update_expense(socket.assigns.expense, expense_params) do
  #     {:ok, expense} ->
  #       notify_parent({:saved, expense})

  #       {:noreply,
  #        socket
  #        |> put_flash(:info, "Expense updated successfully")
  #        |> push_patch(to: socket.assigns.patch)}

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       {:noreply, assign_form(socket, changeset)}
  #   end
  # end

  defp save_expense(socket, expense_params) do
    case Expenses.create_friendship_expense(expense_params) do
      {:ok, expense} ->
        notify_parent({:saved, expense})

        {:noreply,
         socket
         |> put_flash(:info, "Expense created successfully")
         |> push_navigate(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
