defmodule BNote.Reference do
  defmodule Range do
    defstruct start: nil, end: nil
  end
  
  defstruct book: nil, chapter: nil, verse: nil

  def to_part_list(%__MODULE__{book: book, chapter: nil, verse: nil}), do: [book]
  def to_part_list(%__MODULE__{book: book, chapter: chapter, verse: nil}), do: [book, chapter]
  def to_part_list(%__MODULE__{book: book, chapter: chapter, verse: verse}), do: [book, chapter, verse]

  def from_json(%{} = json) do
    values =
      json
      |> Enum.map(fn {k,v} -> {String.to_existing_atom(k), v} end)
      |> Enum.into(%{})

    struct __MODULE__, values
  end
end