defmodule BNote.FileStore.NoteFile do
  alias BNote.Note
  require Logger

  def serialise(%Note{body: body} = note) do
    note
      |> Poison.Encoder.encode([])
  end

  defp meta_data(%Note{} = note) do
    note
      |> Map.drop([:body, :__struct__])
      |> Enum.reject(fn {_,value} -> value == nil end)
      |> Enum.into(%{})
  end

  def read!(path) do
    Logger.info "reading note from file at: #{path}"
    {:ok, f} = File.open path, [:read, :utf8]
    IO.read f, :all
  end
end