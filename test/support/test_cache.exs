:ok = Application.put_env(:nebulex_ecto, Nebulex.Ecto.TestCache, [gc_interval: 3600])

defmodule Nebulex.Ecto.TestCache do
  use Nebulex.Cache, otp_app: :nebulex_ecto, adapter: Nebulex.Adapters.Local
end
