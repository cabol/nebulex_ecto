defmodule NebulexEcto do
  @moduledoc """
  `NebulexEcto` provides the module `NebulexEcto.Repo`, which is the wrapper
  on top of `Nebulex.Cache` and `Ecto.Repo`.

  ## Cacheable Repo

  Suppose you have an Ecto repo and a Nebulex cache separately:

      defmodule MyApp.Cache do
        use Nebulex.Cache,
          otp_app: :my_app,
          adapter: Nebulex.Adapters.Local
      end

      defmodule MyApp.Repo do
        use Ecto.Repo,
          otp_app: :my_app,
          adapter: Ecto.Adapters.Postgres
      end

  The idea is to encapsulate both in a single module using `NebulexEcto.Repo`,
  like so:

      defmodule MyApp.CacheableRepo do
        use NebulexEcto.Repo,
          cache: MyApp.Cache,
          repo: MyApp.Repo
      end

  Configuration would be like this:

      config :my_app, MyApp.Cache,
        gc_interval: 3600

      config :my_app, MyApp.Repo,
        database: "ecto_simple",
        username: "postgres",
        password: "postgres",
        hostname: "localhost"

  Now we can use `MyApp.CacheableRepo` as a regular Ecto repo, of course,
  there are some constraints, `NebulexEcto.Repo` only provides some of
  the `Ecto.Repo` functions (the basic ones – get, get_by, insert, update,
  delete, etc.), please check them out before.

  Usage example:

      schema = %MyApp.MySchema{x: "abc"}

      {:ok, schema} = MyApp.CacheableRepo.insert(schema)

      MyApp.CacheableRepo.get!(MyApp.MySchema, schema.id)

      MyApp.CacheableRepo.get_by!(MyApp.MySchema, [id: schema.id])

      changeset = Ecto.Changeset.change schema, x: "New"
      {:ok, schema} = MyApp.CacheableRepo.update(changeset)

      MyApp.CacheableRepo.delete(schema)
  """
end
