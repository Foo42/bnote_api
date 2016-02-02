defmodule BNote.FileStore.Paths do
  require Logger
  
  def glob_paths_for(%{book: b, chapter: nil, verse: nil}), do: glob_paths_for([b])
  def glob_paths_for(%{book: b, chapter: c, verse: nil}), do: glob_paths_for([b,c])
  def glob_paths_for(%{book: b, chapter: c, verse: v}), do: glob_paths_for([b,c,v])
  def glob_paths_for(parts) when is_list(parts) do
    Logger.info "base_path: #{inspect base_path} parts: #{inspect parts}"
    [(base_path ++ parts ++ ["*.note.md"]) |> Path.join()]
  end

  def base_path(), do: [System.get_env("BASE_PATH"),"notes","by_passage"]
end