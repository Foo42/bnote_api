defmodule BNote.FileStoreTests do
  use ExUnit.Case

  test "keys_to_fetch returns single key when no recurse option" do
    reference = %BNote.Reference{book: "foo"}
    assert BNote.FileStore.keys_to_fetch(reference, []) == [["foo"]]
  end

  test "keys_to_fetch returns additional keys for each level of wildcard when recurse option used" do
    reference = %BNote.Reference{book: "foo"}
    assert BNote.FileStore.keys_to_fetch(reference, recurse: true) == [["foo"],["foo","*"],["foo","*","*"]]
  end
end