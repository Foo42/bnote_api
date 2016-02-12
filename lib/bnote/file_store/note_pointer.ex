defmodule BNote.FileStore.NotePointer do
  require Logger

  def resolve(pointer_file_name) do
    case Path.extname pointer_file_name do
      ".ptr" ->
        target = File.read!(pointer_file_name) |> String.strip
        Logger.info "#{pointer_file_name} redirects to #{target}"
        resolve(Path.join(BNote.FileStore.Paths.base_path, target))
      _ -> pointer_file_name
    end
  end

  def pointer_to(%BNote.Note{id: id}) do
    Path.relative_to(BNote.FileStore.Paths.base_path, BNote.FileStore.path_to_note)
  end

  def read_final_destination(pointer_file_name), do: pointer_file_name |> resolve |> File.read!
end