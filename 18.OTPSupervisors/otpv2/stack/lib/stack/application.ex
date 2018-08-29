defmodule Stack.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      {Stack.Stash, [0]}, # Init with non-empty list to check Stack.Server restart state
      {Stack.Server, nil},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :rest_for_one, name: Stack.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
