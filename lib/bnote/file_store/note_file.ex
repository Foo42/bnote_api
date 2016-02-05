defmodule BNote.FileStore.NoteFile do
  alias BNote.Note
  require Logger

  def serialise(%Note{body: body} = note) do
    body #for now
  end

  def read!(path) do
    Logger.info "reading note from file at: #{path}"
    {:ok, f} = File.open path, [:read, :utf8]
    IO.read f, :all
  end
end