# Nebulex.Ecto

A project that integrates [Nebulex](https://github.com/cabol/nebulex)
with [Ecto](https://github.com/elixir-ecto/ecto).

> It's still a **WIP**

## Installation

Add `nebulex_ecto` to your list dependencies in `mix.exs`:

```elixir
def deps do
  [{:nebulex_ecto, github: "cabol/nebulex_ecto"}]
end
```

## Example

Suppose you have an Ecto repo:

```elixir
defmodule MyApp.Repo do
  use Ecto.Repo, otp_app: :my_app
end
```

And a Nebulex cache:

```elixir
defmodule MyApp.Cache do
  use Nebulex.Cache, otp_app: :my_app
end
```

The idea is to encapsulate both in a single module using `Nebulex.Ecto.Repo`,
like:

```elixir
defmodule MyApp.CacheableRepo do
  use Nebulex.Ecto.Repo, otp_app: :my_app
end
```

Configuration would be like this:

```elixir
config :my_app, MyApp.CacheableRepo,
  cache: MyApp.Cache,
  repo: MyApp.Repo

config :my_app, MyApp.Cache,
  adapter: Nebulex.Adapters.Local

config :my_app, MyApp.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "ecto_simple",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"
```

Now we can use `MyApp.CacheableRepo` as a regular Ecto repo, of course,
there are some constraints, [`Nebulex.Ecto.Repo`](lib/nebulex_ecto/repo.ex)
only provides some of the `Ecto.Repo` functions (the basic ones – get, get_by,
insert, update, delete, etc.), [please check them out before](lib/nebulex_ecto/repo.ex).

Usage example:

First, let's define a schema:

```elixir
defmodule MyApp.MySchema do
  use Ecto.Schema

  schema "my_schema" do
    field :x, :string
    field :y, :binary
    field :z, :string, default: "z"
  end
end
```

Now we can play with it:

```elixir
schema = %MyApp.MySchema{x: "abc"}

{:ok, schema} = MyApp.CacheableRepo.insert(schema)

MyApp.CacheableRepo.get!(MyApp.MySchema, schema.id)

MyApp.CacheableRepo.get_by!(MyApp.MySchema, [id: schema.id])

changeset = Ecto.Changeset.change schema, x: "New"
{:ok, schema} = MyApp.CacheableRepo.update(changeset)

MyApp.CacheableRepo.delete(schema)
```
