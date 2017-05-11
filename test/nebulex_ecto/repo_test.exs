defmodule Nebulex.Ecto.RepoTest do
  use ExUnit.Case, async: true

  alias Nebulex.Ecto.TestRepo, as: Repo
  alias Nebulex.Ecto.TestCache, as: Cache
  alias Nebulex.Ecto.CacheableRepo

  defmodule MySchema do
    use Ecto.Schema

    schema "my_schema" do
      field :x, :string
      field :y, :binary
      field :z, :string, default: "z"
      field :array, {:array, :string}
      field :map, {:map, :string}
    end
  end

  setup do
    {:ok, pid} = Cache.start_link(n_generations: 2)
    :ok

    on_exit fn ->
      _ = :timer.sleep(10)
      if Process.alive?(pid), do: Cache.stop(pid, 1)
    end
  end

  test "fail on compile_config because missing cache config" do
    assert_raise ArgumentError, ~r"missing :cache configuration in config", fn ->
      defmodule MissingNebulexEctoConfig do
        use Nebulex.Ecto.Repo, otp_app: :nebulex_ecto, repo: Nebulex.Ecto.TestRepo
      end
    end
  end

  test "fail on compile_config because missing repo config" do
    assert_raise ArgumentError, ~r"missing :repo configuration in config", fn ->
      defmodule MissingNebulexEctoConfig do
        use Nebulex.Ecto.Repo, otp_app: :nebulex_ecto, cache: Nebulex.Ecto.TestCache
      end
    end
  end

  test "get and get!" do
    schema = %MySchema{id: 1, x: "abc"}
    {:ok, _} = Repo.insert(schema)

    # shouldn't be in cache
    refute Cache.get({MySchema, 1})

    # shouldn't be in cache neither in repo
    refute CacheableRepo.get(MySchema, -1)
    assert_raise Ecto.NoResultsError, fn ->
      CacheableRepo.get!(MySchema, -1)
    end

    # fetch from repo and put it in cache
    assert CacheableRepo.get(MySchema, 1)
    assert Cache.get!({MySchema, 1})

    # remove from repo and it should be still cached
    assert Repo.delete!(schema)
    assert CacheableRepo.get!(MySchema, 1)
  end

  test "get_by and get_by!" do
    schema = %MySchema{id: 1, x: "abc"}
    {:ok, _} = Repo.insert(schema)

    refute Cache.get({MySchema, 1})
    assert CacheableRepo.get_by(MySchema, [id: 1])
    assert Cache.get({MySchema, [id: 1]})
    assert Cache.get!({MySchema, [id: 1]})

    refute CacheableRepo.get_by(MySchema, [id: -1])
    assert_raise Ecto.NoResultsError, fn ->
      CacheableRepo.get_by!(MySchema, [id: -1])
    end
  end

  test "insert and insert!" do
    assert Cache.set({MySchema, 1}, 1)
    assert Cache.get({MySchema, 1})

    schema = %MySchema{id: 1, x: "abc"}
    {:ok, _} = CacheableRepo.insert(schema)
    refute Cache.get({MySchema, 1})

    _ = CacheableRepo.insert!(schema, nbx_evict: :replace)
    assert Cache.get!({MySchema, 1})

    changeset = Ecto.Changeset.change schema, x: "New"
    changeset = Ecto.Changeset.add_error(changeset, :z, "empty")
    {:error, _} = CacheableRepo.insert(changeset)
    assert_raise Ecto.InvalidChangesetError, fn ->
      CacheableRepo.insert!(changeset)
    end
    assert Cache.get({MySchema, 1})
  end

  test "update and update!" do
    schema = %MySchema{id: 1, x: "abc"}
    {:ok, _} = Repo.insert(schema)

    refute Cache.get({MySchema, 1})

    schema = %MySchema{id: 1, x: "abc"}
    changeset = Ecto.Changeset.change schema, x: "New"
    {:ok, _} = CacheableRepo.update(changeset)
    refute Cache.get({MySchema, 1})

    changeset = Ecto.Changeset.change schema, x: "New"
    _ = CacheableRepo.update!(changeset, nbx_evict: :replace)
    assert Cache.get!({MySchema, 1})

    changeset = Ecto.Changeset.change schema, x: "New"
    changeset = Ecto.Changeset.add_error(changeset, :z, "empty")
    {:error, _} = CacheableRepo.update(changeset)
    assert_raise Ecto.InvalidChangesetError, fn ->
      CacheableRepo.update!(changeset)
    end
    assert Cache.get({MySchema, 1})
  end

  test "delete and delete!" do
    schema = %MySchema{id: 1, x: "abc"}
    {:ok, _} = Repo.insert(schema)

    refute Cache.get({MySchema, 1})
    assert CacheableRepo.get(MySchema, 1)
    assert Cache.get!({MySchema, 1})

    {:ok, _} = CacheableRepo.delete(schema)
    refute Cache.get({MySchema, 1})

    {:ok, _} = Repo.insert(schema)
    assert CacheableRepo.get(MySchema, 1)
    assert Cache.get!({MySchema, 1})

    _ = CacheableRepo.delete!(schema)
    refute Cache.get({MySchema, 1})

    _ = CacheableRepo.insert!(schema, nbx_evict: :replace)
    assert Cache.get!({MySchema, 1})

    changeset = Ecto.Changeset.change schema, x: "New"
    changeset = Ecto.Changeset.add_error(changeset, :z, "empty")
    {:error, _} = CacheableRepo.delete(changeset)
    assert_raise Ecto.InvalidChangesetError, fn ->
      CacheableRepo.delete!(changeset)
    end
    assert Cache.get({MySchema, 1})
  end

  test "insert_or_update and insert_or_update!" do
    assert Cache.set({MySchema, 1}, 1)
    assert Cache.get({MySchema, 1})

    schema = %MySchema{id: 1, x: "abc"}
    changeset = Ecto.Changeset.change schema, x: "New"
    {:ok, _} = CacheableRepo.insert_or_update(changeset)
    refute Cache.get({MySchema, 1})

    _ = CacheableRepo.insert_or_update!(changeset, nbx_evict: :replace)
    assert Cache.get!({MySchema, 1})

    changeset = Ecto.Changeset.add_error(changeset, :z, "empty")
    {:error, _} = CacheableRepo.insert_or_update(changeset)
    assert_raise Ecto.InvalidChangesetError, fn ->
      CacheableRepo.insert_or_update!(changeset)
    end
    assert Cache.get({MySchema, 1})
  end
end
