defmodule BNote.FileStore.ReferenceIndex do
  alias BNote.Note
  alias BNote.Reference

  def map(%Note{id: id} = note) do
    note.primary_references
      |> Enum.map(&{reference_to_index_key(&1),id})
  end

  def reference_to_index_key(%Reference{} = reference), do: reference |> Reference.to_part_list
  def key_to_path(key), do: Path.join(BNote.FileStore.Paths.base_path(:notes_by_passage) ++ key)
end