defmodule BNote.FileStore.NoteFileTests do
  alias BNote.FileStore.NoteFile
  alias BNote.Note
  alias BNote.Reference
  use ExUnit.Case

  test "deserialise can deserialise a note with simple primary_references" do
    input = %{"primary_references" => [%{"book" => "Exodus", "chapter" => 1, "verse" => 2}], "id" => "some id", "body" => "some body"}
    expected = %Note{primary_references: [%Reference{book: "Exodus", chapter: 1, verse: 2}], id: "some id", body: "some body"}
    assert NoteFile.deserialise(input) == expected
  end

  test "deserialise can deserialise a note with reference ranges in primary_references" do
    input = %{
      "primary_references" => [
        %{
          "start" => %{"book" => "Exodus", "chapter" => 1, "verse" => 2},
          "end" => %{"book" => "Exodus", "chapter" => 1, "verse" => 5}
        }
      ],
      "id" => "some id",
      "body" => "some body"
    }

    expected = %Note{primary_references: [%Reference.Range{ start: %Reference{book: "Exodus", chapter: 1, verse: 2}, end: %Reference{book: "Exodus", chapter: 1, verse: 5}}], id: "some id", body: "some body"}
    assert NoteFile.deserialise(input) == expected
  end
end