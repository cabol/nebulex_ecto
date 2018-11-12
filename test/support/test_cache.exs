defmodule NebulexEcto.TestCache do
  use Nebulex.Cache,
    otp_app: :nebulex_ecto,
    adapter: Nebulex.Adapters.Local
end
