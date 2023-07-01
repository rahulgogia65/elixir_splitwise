defmodule ElixirSplitwiseWeb.Live.Dashboard.Modals.AddFriend do
  use ElixirSplitwiseWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, form: to_form(%{}))}
  end
end
