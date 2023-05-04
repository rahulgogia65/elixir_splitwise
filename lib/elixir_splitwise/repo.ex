defmodule ElixirSplitwise.Repo do
  use Ecto.Repo,
    otp_app: :elixir_splitwise,
    adapter: Ecto.Adapters.Postgres
end
