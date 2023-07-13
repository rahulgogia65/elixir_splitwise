defmodule ElixirSplitwiseWeb.FriendshipLive do
  use ElixirSplitwiseWeb, :live_view
  alias ElixirSplitwise.Accounts.Friendship

  alias ElixirSplitwise.Expenses.Expense

  @impl true
  def mount(params, _session, socket) do
    current_user = socket.assigns.current_user
    friendship_id = String.to_integer(params["id"])

    if friendship_id && Friendship.is_user_in_friendship?(current_user, friendship_id) do
      {:ok,
       assign(socket,
         friendship_id: friendship_id,
         friend: friend(current_user, friendship_id),
         friends_list: Friendship.get_friends_list(current_user)
       )}
    else
      case friendship_id do
        nil ->
          {:ok, socket |> put_flash(:error, "Action not allowed") |> redirect(to: "/dashboard")}

        _ ->
          {:ok, socket |> put_flash(:error, "Friend not found") |> redirect(to: "/dashboard")}
      end
    end
  end

  @impl true
  def handle_params(_params, url, socket) do
    socket =
      socket
      |> assign(:page_title, "Add an Expense")
      |> assign(:expense, %Expense{})
      |> assign(:url, URI.parse(url))

    {:noreply, socket}
  end

  defp friend(current_user, friendship_id) do
    Friendship.get_friend(current_user, friendship_id)
  end

  # @impl true
  # def handle_event("add_expense", unsigned_params, socket) do
  #   IO.inspect(unsigned_params, label: "..........................Parmas unsigned")
  #   {:ok, socket}
  # end

  # defp apply_action(socket, :add_expense, _params, _url) do
  #   socket
  #   |> assign(:page_title, "Add an Expense")
  #   |> assign(:expense, %Expense{})
  # end

  # defp apply_action(socket, nil, _params, url) do
  #   socket
  #   |> assign(:url, URI.parse(url))
  # end
end
