defmodule BNote.FileStore do
  alias BNote.Note
  alias BNote.FileStore.NoteFile
  alias BNote.Reference
  require Logger

  use GenServer
  @name __MODULE__

  def start_link, do: GenServer.start_link(__MODULE__, %{counter: 0}, name: @name)
  def store_note(%Note{} = note), do: GenServer.call(@name, {:store_note, note})

  #######################
  def handle_call({:store_note, %Note{} = note}, _from, state) do
    note = ensure_has_id(note)
    note
      |> path_for_note
      |> File.write!(NoteFile.serialise(note))

    BNote.GenIndex.rebuild_index BNote.FileStore.ReferenceIndex

    {:reply, note, state}
  end

  def ensure_has_id(%Note{id: nil} = note) do
    {:ok, id} = Timex.Date.universal |> Timex.DateFormat.format("{ISO}")
    %Note{note | id: id}
  end

  def ensure_has_id(%Note{} = note), do: note

  def path_for_note(%Note{id: id}) do
    path_for_note id
  end

  def path_for_note(id) do
    base_notes_path
      |> Path.join("#{id}.note.md")
  end

  def base_notes_path do
    BNote.FileStore.Paths.base_path |> Path.join("notes")
  end

  def get_all_notes() do
    Path.join([base_notes_path, "**", "*.note.md"])
    |> Path.wildcard
    |> read_notes_at
  end

  def get_notes(%BNote.Reference{} = reference, options \\ []) do
    keys = keys_to_fetch(reference, options)

    keys
      |> Enum.flat_map(&BNote.GenIndex.get(BNote.FileStore.ReferenceIndex, &1))
      |> Enum.map(&path_for_note/1)
      |> Enum.dedup
      |> read_notes_at
  end

  def keys_to_fetch(%BNote.Reference{} = reference, options) do
    base_key =
      reference
      |> BNote.Reference.to_part_list
      |> Enum.map(fn
        s when is_binary(s) -> s
        n when is_integer(n) -> Integer.to_string(n)
      end)

    [base_key] ++ derive_keys(base_key, options)
  end

  def derive_keys(key, []), do: []
  def derive_keys([_,_,_], _), do: []
  def derive_keys([b], recurse: true), do: [[b,"*"]] ++ derive_keys([b,"*"], recurse: true)
  def derive_keys([b,c], recurse: true), do: [[b,c,"*"]]

  def read_notes_at(paths) when is_list(paths) do
    Logger.info "readings notes from paths: #{inspect paths}"
    paths
    |> Enum.map(&{&1, Task.async(fn -> read_note_at(&1) end)})
    |> Enum.map(fn {path, getting_text} -> {path, Task.await(getting_text)} end)
    |> Enum.flat_map(fn
      {path, {:ok, body}} -> [body]
      _ -> []
    end)
  end

  def read_note_at(path) do
    path
      |> BNote.FileStore.NotePointer.resolve
      |> BNote.FileStore.NoteFile.read
  end
end