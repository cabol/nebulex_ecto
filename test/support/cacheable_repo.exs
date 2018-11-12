defmodule NebulexEcto.CacheableRepo do
  use NebulexEcto.Repo,
    cache: NebulexEcto.TestCache,
    repo: NebulexEcto.TestRepo
end
