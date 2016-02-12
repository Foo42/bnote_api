defmodule BNote.FileStore.Indexing.Supervisor do
  alias BNote.GenIndex
  alias BNote.FileStore.ReferenceIndex
  use Supervisor
  require Logger

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  #Implementation

  def init(:ok) do
    Logger.info "#{__MODULE__}  starting"
    supervise(children(), strategy: :one_for_one)
  end

  defp children() do
    [worker(GenIndex, [%GenIndex.State{index_module: ReferenceIndex, path: index_path(:reference_index) }, [name: ReferenceIndex]])]
  end

  def index_path(:reference_index), do: Path.join([BNote.FileStore.Paths.base_path, "indexes", "references"])
end