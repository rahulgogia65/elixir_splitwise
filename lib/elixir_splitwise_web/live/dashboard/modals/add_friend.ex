defmodule ElixirSplitwiseWeb.Live.Dashboard.Modals.AddFriend do
  use ElixirSplitwiseWeb, :live_view
  alias ElixirSplitwise.{Accounts, Accounts.User}

  def mount(params, _session, socket) do
    {:ok, assign(socket, form: params)}
  end

  # def handle_call("submitted", params, socket) do
  #   {:noreply, assign(socket, form: to_form(params))}
  # end
end
