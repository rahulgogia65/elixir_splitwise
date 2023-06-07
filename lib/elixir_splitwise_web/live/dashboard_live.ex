defmodule ElixirSplitwiseWeb.Live.DashboardLive do
  use ElixirSplitwiseWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, counter: 0, layout: {ElixirSplitwiseWeb.Layouts, :live} )}
  end
end
