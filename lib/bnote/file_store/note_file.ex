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
    path
      |> File.read!
      |> deserialise
  end

  def read(path) do
    Logger.info "reading note from file at: #{path}"
    case File.read(path) do
      {:ok, body} -> {:ok, deserialise(body)}
      {:error, reason} ->
        Logger.debug "failed to read #{path}, with error #{inspect reason}"
        {:error, reason}
    end
  end

  def deserialise(json_string) when is_binary(json_string), do: Poison.Parser.parse!(json_string) |> deserialise
  def deserialise(%{} = json) do
    values =
      json
      |> Enum.map(fn {k,v} -> {String.to_existing_atom(k), v} end)
      |> Enum.into(%{})
      |> deserialise_references
    struct Note, values
  end

  def deserialise_references(%{primary_references: references} = values) do
    deserialised =
    references
      |> Enum.map(&BNote.Reference.from_json/1)

    %{values | primary_references: deserialised}
  end

  def deserialise_references(x), do: x
end