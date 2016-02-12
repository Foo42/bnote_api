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

    note
      |> path_for_note
      |> File.write!(NoteFile.serialise(note))

    BNote.GenIndex.rebuild_index BNote.FileStore.ReferenceIndex

    note
  end

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

  def get_notes(%BNote.Reference{} = reference) do
    key =
      reference
      |> BNote.Reference.to_part_list

    BNote.GenIndex.get(BNote.FileStore.ReferenceIndex, key)
      |> Enum.map(&path_for_note/1)
      |> read_notes_at
  end

  def read_notes_at(paths) when is_list(paths) do
    Logger.info "readings notes from paths: #{inspect paths}"
    paths
    |> Enum.map(&{&1, Task.async(fn -> read_note_at(&1) end)})
    |> Enum.map(fn {path, getting_text} -> {path, Task.await(getting_text)} end)
    |> Enum.map(fn {path, body} -> body end)
  end

  def read_note_at(path) do
    path
      |> BNote.FileStore.NotePointer.resolve
      |> BNote.FileStore.NoteFile.read!
  end
end