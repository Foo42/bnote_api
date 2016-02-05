defmodule BNote.FileStore do
  alias BNote.Note
  alias BNote.FileStore.NoteFile
  alias BNote.Reference
  require Logger

  def store_note(%Note{id: nil} = note) do
    %Note{note | id: 42} |> store_note
  end

  def store_note(%Note{} = note) do
    Logger.debug "storing #{inspect note}"

    base_notes_path
      |> Path.join("#{note.id}.note.md")
      |> File.write!(NoteFile.serialise(note))

    note
  end

  def base_notes_path do
    BNote.FileStore.Paths.base_path |> Path.join("notes")
  end

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
    |> Enum.map(&{&1, Task.async(fn -> read_note_at(&1) end)})
    |> Enum.map(fn {path, getting_text} -> {path, Task.await(getting_text)} end)
    |> Enum.map(fn {path, body} -> %{path: path, body: body} end)
  end

  def read_note_at(path) do
    path
      |> BNote.FileStore.NotePointer.resolve
      |> BNote.FileStore.NoteFile.read!
  end
end