defmodule BNote.NoteController do
  use BNote.Web, :controller

  def get_notes(conn, params) do
    notes =
      params
      |> extract_reference
      |> BNote.FileStore.get_notes
    text conn, inspect(notes)
  end

  def create(conn, params) do
    note = params
      |> extract_note
      |> BNote.FileStore.store_note

    put_status conn, 201
    put_resp_header conn, "location", note_url(note)
    text conn, "created"
  end

  defp note_url(note) do
    "/notes/#{note.id}"
  end

  defp extract_note(params) do
    about = params["about"] |> extract_reference
    %BNote.Note{primary_references: [about], body: params["body"]}
  end

  defp extract_reference(params) do
    fields =
      params
      |> Dict.take(["book", "chapter", "verse"])
      |> Enum.map(fn {k,v} -> {String.to_existing_atom(k), v}end)
      |> Enum.into(%{})

    struct(BNote.Reference, fields)
      |> expand_bookname
  end

  defp expand_bookname(%BNote.Reference{book: bookname} = reference) do
    {:ok, full_name} = BNote.Booknames.to_full(bookname)
    %BNote.Reference{reference | book: full_name}
  end
end
