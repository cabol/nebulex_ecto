# NebulexEcto
> ### Ecto & Nebulex Integration
> Ecto Cacheable Repo with Nebulex

[![Build Status](https://travis-ci.org/cabol/nebulex_ecto.svg?branch=master)](https://travis-ci.org/cabol/nebulex_ecto)
[![Coverage Status](https://coveralls.io/repos/github/cabol/nebulex_ecto/badge.svg?branch=master)]

A project that integrates [Nebulex](https://github.com/cabol/nebulex)
with [Ecto](https://github.com/elixir-ecto/ecto) out-of-box.

## Installation

Add `nebulex_ecto` to your list dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:nebulex_ecto, github: "cabol/nebulex_ecto"}
  ]
end
```

## Example

Suppose you have an Ecto repo:

```elixir
defmodule MyApp.Repo do
  use Ecto.Repo,
    otp_app: :my_app,
    adapter: Ecto.Adapters.Postgres
end
```

And a Nebulex cache:

```elixir
defmodule MyApp.Cache do
  use Nebulex.Cache,
    otp_app: :my_app,
    adapter: Nebulex.Adapters.Local
end
```

The idea is to encapsulate both in a single module by means of
`NebulexEcto.Repo`, like so:

```elixir
defmodule MyApp.CacheableRepo do
  use NebulexEcto.Repo,
    cache: MyApp.Cache,
    repo: MyApp.Repo
end
```

Now we can use `MyApp.CacheableRepo` as a regular Ecto repo, of course,
there are some constraints, [`NebulexEcto.Repo`](lib/nebulex_ecto/repo.ex)
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

## Running Tests

To run the tests:

```
$ mix test
```

Running tests with coverage:

```
$ mix coveralls.html
```

And you can check out the coverage result in `cover/excoveralls.html`.
