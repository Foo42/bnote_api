defmodule BNote.FooControllerTest do
  use BNote.ConnCase

  alias BNote.Foo
  @valid_attrs %{body: "some content", book: "some content", chapter: 42, verse: 42}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, foo_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing foo"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, foo_path(conn, :new)
    assert html_response(conn, 200) =~ "New foo"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, foo_path(conn, :create), foo: @valid_attrs
    assert redirected_to(conn) == foo_path(conn, :index)
    assert Repo.get_by(Foo, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, foo_path(conn, :create), foo: @invalid_attrs
    assert html_response(conn, 200) =~ "New foo"
  end

  test "shows chosen resource", %{conn: conn} do
    foo = Repo.insert! %Foo{}
    conn = get conn, foo_path(conn, :show, foo)
    assert html_response(conn, 200) =~ "Show foo"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, foo_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    foo = Repo.insert! %Foo{}
    conn = get conn, foo_path(conn, :edit, foo)
    assert html_response(conn, 200) =~ "Edit foo"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    foo = Repo.insert! %Foo{}
    conn = put conn, foo_path(conn, :update, foo), foo: @valid_attrs
    assert redirected_to(conn) == foo_path(conn, :show, foo)
    assert Repo.get_by(Foo, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    foo = Repo.insert! %Foo{}
    conn = put conn, foo_path(conn, :update, foo), foo: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit foo"
  end

  test "deletes chosen resource", %{conn: conn} do
    foo = Repo.insert! %Foo{}
    conn = delete conn, foo_path(conn, :delete, foo)
    assert redirected_to(conn) == foo_path(conn, :index)
    refute Repo.get(Foo, foo.id)
  end
end
