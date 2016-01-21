ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Segfault.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Segfault.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Segfault.Repo)

