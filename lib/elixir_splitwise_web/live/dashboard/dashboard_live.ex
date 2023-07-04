defmodule ElixirSplitwiseWeb.Dashboard.DashboardLive do
  use ElixirSplitwiseWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, counter: 0)}
  end
end
