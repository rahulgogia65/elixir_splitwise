defmodule ElixirSplitwiseWeb.GroupHTML do
  use ElixirSplitwiseWeb, :html

  alias Phoenix.LiveView.JS

  embed_templates "group_html/*"

  def show_and_hide(selector1, selector2) do
    JS.add_class("hidden", to: selector1) |> JS.remove_class("hidden", to: selector2)
  end

  def options do
    ["Home": "home", "Trip": "trip", "Couple": "couple", "Other": "other"]
  end
end
