defmodule Triviacalypse.GameRepo do
  alias Triviacalypse.{Game, GameRegistry, GameServer, GameSupervisor}

  @type game :: Game.t()

  @spec all :: [pid]
  def all, do: list_pids()

  @spec get(binary) :: pid | :undefined
  def get(id) do
    case Registry.lookup(GameRegistry, id) do
      [{pid, _value}] -> pid
      _ -> :undefined
    end
  end

  @spec insert(game) :: {:ok, pid} | {:error, any}
  def insert(game) do
    child_spec = {GameServer, game: game, name: via_name(game.id)}

    case DynamicSupervisor.start_child(GameSupervisor, child_spec) do
      {:ok, pid} -> {:ok, pid}
      {:error, {:already_started, pid}} -> {:ok, pid}
      {:error, error} -> {:error, error}
    end
  end

  @spec delete(binary | game | pid) :: :ok | :error
  def delete(%Game{id: id}), do: delete(id)

  def delete(pid) when is_pid(pid) do
    GameServer.kill(pid)
  end

  def delete(id) when is_binary(id) do
    id
    |> get()
    |> delete()
  end

  def delete(_), do: :error

  @spec delete_all :: :ok
  def delete_all do
    list_pids()
    |> Enum.each(&GameServer.kill/1)
  end

  defp via_name(id) do
    {:via, Registry, {GameRegistry, id}}
  end

  defp list_pids do
    GameSupervisor
    |> DynamicSupervisor.which_children()
    |> Enum.map(fn {_id, child, _type, _modules} -> child end)
  end
end
