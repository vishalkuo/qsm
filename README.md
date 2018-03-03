# Qsm

A state machine built that leverages SQS to act in a distributed manner.

Official documentation can be found [here](https://hexdocs.pm/qsm/0.1.0/api-reference.html).

### Note About Authentication

If you're planning on using config file authentication, the following needs to be added to your
`config.exs`:

```elixir
config :ex_aws,
  access_key_id: [{:system, "AWS_ACCESS_KEY_ID"}, {:awscli, "default", 30}, :instance_role],
  secret_access_key: [{:system, "AWS_SECRET_ACCESS_KEY"}, {:awscli, "default", 30}, :instance_role]
```

## Installation

Add `qsm` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:qsm, "~> 0.1.0"}]
end
```

and run `$ mix deps.get`.

## Usage
```elixir
iex(1)> defmodule Qsm.MockEntryState do
...(1)>   @behaviour Qsm.State
...(1)>
...(1)>   def get_next_state(m) do
...(1)>     IO.inspect m
...(1)>     Process.sleep 1000
...(1)>     {Qsm.MockExitState, m}
...(1)>   end
...(1)> end
iex(2)> defmodule Qsm.MockExitState do
...(2)>   @behaviour Qsm.State
...(2)>
...(2)>   def get_next_state(_m) do
...(2)>     nil
...(2)>   end
...(2)> end
iex(3)> Qsm.enqueue_work("my_worker_queue", Qsm.MockEntryState, "foo")
:ok
iex(4)> {:ok, pid} = Qsm.start_link("my_worker_queue")
iex(5)> Qsm.run_async(pid)
:ok
"foo"
```

Every state should implement the `Qsm.State` behaviour. All you need to define a `get_next_state` function that takes a serializable message and returns either a `Qsm.State` or `nil`. 
