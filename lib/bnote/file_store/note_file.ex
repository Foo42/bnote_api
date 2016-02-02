defmodule BNote.FileStore.NoteFile do
  require Logger
  
  def read!(path) do
    Logger.info "reading note from file at: #{path}"
    {:ok, f} = File.open path, [:read, :utf8]
    IO.read f, :all
  end
end