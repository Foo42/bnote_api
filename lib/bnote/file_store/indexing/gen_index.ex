defmodule BNote.GenIndex do
  use GenServer
  require Logger

  defmodule State do
    defstruct index_module: nil, path: nil, note_access: BNote.FileStore
  end

  def start_link(%__MODULE__.State{} = config, opts \\ []) do
    GenServer.start_link(__MODULE__, config, opts)
  end

  def init(%__MODULE__.State{} = state) do
    Logger.info "Starting #{inspect state.index_module} index"
    File.mkdir_p! state.path
    {:ok, state}
  end

  def rebuild_index(index), do: GenServer.call(index, {:rebuild_index})

  def get(index, key) when is_list(key), do: GenServer.call(index, {:get, key})

  def handle_call({:rebuild_index}, _from, %__MODULE__.State{path: base_path} = state) do
    Logger.info "rebuilding index #{inspect state.index_module}..."

    updates =
      state.note_access.get_all_notes
      |> Stream.flat_map(&state.index_module.map/1)
      |> Stream.map(&to_file_command(base_path, &1))

    Logger.debug("index #{inspect state.index_module} generated: #{inspect Enum.to_list(updates)}")

    updates
      |> Enum.each(&to_file_system/1)

    {:reply, :ok, state}
  end

  def handle_call({:get, key}, _from, %__MODULE__.State{path: base_path} = state) do
    note_ids =
      key
      |> key_to_path("*", base_path)
      |> Path.wildcard
      |> get_target_id
      |> Enum.uniq

    {:reply, note_ids, state}
  end

  defp get_target_id(path) do
    path
      |> Enum.map(&Path.split/1)
      |> Enum.map(&List.last/1)
      |> Enum.map(&String.split(&1, "."))
      |> Enum.map(&Enum.at(&1, 0))
  end

  def to_file_command(base_path, {key, target}) do
    path = key_to_path(key,target, base_path)
    {:write, {path, inspect(target)}}
  end

  def key_to_path(key, target, base_path), do: Path.join([base_path] ++ key ++ ["#{target}.note.id"])

  defp to_file_system({:write, {path, contents}}) do
    path
      |> Path.dirname
      |> File.mkdir_p

    File.write!(path, contents)
  end
end