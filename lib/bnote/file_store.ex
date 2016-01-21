defmodule BNote.FileStore do
  require Logger

  def get_notes(%BNote.Reference{} = reference) do
    paths = reference
    |> search_paths

    Logger.debug "paths: #{inspect paths}"

    paths
    |> Enum.map(&Path.wildcard(&1))
    |> List.flatten
    |> read_notes_at
  end

  def search_paths(%{book: b, chapter: nil, verse: nil}), do: search_paths([b])
  def search_paths(%{book: b, chapter: c, verse: nil}), do: search_paths([b,c])
  def search_paths(%{book: b, chapter: c, verse: v}), do: search_paths([b,c,v])
  def search_paths(parts) when is_list(parts) do
    Logger.info "base_path: #{inspect base_path} parts: #{inspect parts}"
    [(base_path ++ parts ++ ["*.note.md"]) |> Path.join()]
  end

  def base_path(), do: [System.get_env("BASE_PATH"),"notes","by_passage"]

  def read_note_at(note_path) do
    Logger.info "reading note from file at: #{note_path}"
    {:ok, f} = File.open note_path, [:read, :utf8]
    IO.read f, :all
  end

  def read_notes_at(paths) when is_list(paths) do
    Logger.info "readings notes from paths: #{inspect paths}"
    paths
    |> Enum.map(&{&1, Task.async(fn -> read_note_at(&1) end)})
    |> Enum.map(fn {path, getting_text} -> {path, Task.await(getting_text)} end)
    |> Enum.map(fn {path, body} -> %{path: path, body: body} end)
  end
end