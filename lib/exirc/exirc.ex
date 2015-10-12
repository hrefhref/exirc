defmodule ExIrc do
  @moduledoc """
  Supervises IRC client processes

  Usage:

      # Start the supervisor (started automatically when ExIrc is run as an application)
      ExIrc.start_link

      # Start a new IRC client
      {:ok, client} = ExIrc.start_client!

      # Connect to an IRC server
      ExIrc.Client.connect! client, "localhost", 6667

      # Logon
      ExIrc.Client.logon client, "password", "nick", "user", "name"

      # Join a channel (password is optional)
      ExIrc.Client.join client, "#channel", "password"

      # Send a message
      ExIrc.Client.msg client, :privmsg, "#channel", "Hello world!"

      # Quit (message is optional)
      ExIrc.Client.quit client, "message"

      # Stop and close the client connection
      ExIrc.Client.stop! client

  """
  use Supervisor

  ##############
  # Public API
  ##############

  @doc """
  Start the ExIrc supervisor.
  """
  @spec start! :: {:ok, pid} | {:error, term}
  def start! do
    Supervisor.start_link(__MODULE__, [], name: {:local, :exirc})
  end

  @doc """
  Start a new ExIrc client
  """
  @spec start_client! :: {:ok, pid} | {:error, term}
  def start_client!(options \\ []) do
    # Start the client worker
    Supervisor.start_child(:exirc, [options])
  end

  ##############
  # Supervisor API
  ##############

  @spec init(any) :: {:ok, pid} | {:error, term}
  def init(_) do
    supervise [worker(ExIrc.Client, [], [restart: :temporary])], strategy: :simple_one_for_one
  end

end
