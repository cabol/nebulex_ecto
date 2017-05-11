defmodule Nebulex.Ecto.CacheableRepo do
  use Nebulex.Ecto.Repo, otp_app: :nebulex_ecto, cache: Nebulex.Ecto.TestCache, repo: Nebulex.Ecto.TestRepo
end
