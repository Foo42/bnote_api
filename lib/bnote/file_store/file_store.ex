defmodule BNote.FileStore do
  require Logger

  def get_notes(%BNote.Reference{} = reference) do
    paths = BNote.FileStore.Paths.glob_paths_for reference

    Logger.debug "paths: #{inspect paths}"

    paths
      |> Enum.map(&Path.wildcard(&1))
      |> List.flatten
      |> read_notes_at
  end

  def read_notes_at(paths) when is_list(paths) do
    Logger.info "readings notes from paths: #{inspect paths}"
    paths
    |> Enum.map(&{&1, Task.async(fn -> BNote.FileStore.NoteFile.read!(&1) end)})
    |> Enum.map(fn {path, getting_text} -> {path, Task.await(getting_text)} end)
    |> Enum.map(fn {path, body} -> %{path: path, body: body} end)
  end
end