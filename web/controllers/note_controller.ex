defmodule BNote.NoteController do
  use BNote.Web, :controller

  def new(conn, _params) do
    render conn, "new.html"
  end

  def get_notes(conn, params) do
    reference =
      params
      |> extract_reference

    notes = case Map.get(params, "recurse") do
      "true" -> BNote.FileStore.get_notes(reference, recurse: true)
      _ -> BNote.FileStore.get_notes(reference)
    end

    json conn, notes
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
    about = params |> extract_reference
    %BNote.Note{primary_references: [about], body: params["body"]}
  end

  defp extract_reference(%{"book" => _} = params) do
    about = params |> Dict.take(~w{book chapter verse})
    extract_reference(%{"about" => about})
  end
  defp extract_reference(%{"about" => params}) do
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
