defmodule BNote.FooTest do
  use BNote.ModelCase

  alias BNote.Foo

  @valid_attrs %{body: "some content", book: "some content", chapter: 42, verse: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Foo.changeset(%Foo{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Foo.changeset(%Foo{}, @invalid_attrs)
    refute changeset.valid?
  end
end
