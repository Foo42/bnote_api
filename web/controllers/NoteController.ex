defmodule BNote.NoteController do
  use BNote.Web, :controller

  def get_notes(conn, params) do
    notes =
      params
      |> extract_reference
      |> BNote.FileStore.get_notes
    text conn, inspect(notes)
  end

  defp extract_reference(params) do
    fields =
      params
      |> Dict.take(["book", "chapter", "verse"])
      |> Enum.map(fn {k,v} -> {String.to_existing_atom(k), v}end)
      |> Enum.into(%{})
    struct(BNote.Reference, fields)
  end
end
