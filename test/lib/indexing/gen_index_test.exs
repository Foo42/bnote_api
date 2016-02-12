defmodule BNote.GenIndexTests do
  use ExUnit.Case
  alias BNote.GenIndex

  defmodule TestIndex do

  end

  test "can create" do
    {:ok, pid} = GenIndex.start_link %GenIndex.State{index_module: TestIndex, path: "/tmp/bnote_tests/default_index"}
  end
end