defmodule BNote.BooknamesTest do
  use ExUnit.Case

  test "getting canonical book name from partial"  do
    partial = "ex"
    assert {:ok, "exodus"} == BNote.Booknames.to_full(partial)
  end

  test "getting canonical book name from ambigoups partial returns possibilites"  do
    partial = "ma"
    assert {:ambiguous, ["malachi", "mark", "matthew"]} == BNote.Booknames.to_full(partial)
  end
end
