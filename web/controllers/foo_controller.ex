defmodule BNote.FooController do
  use BNote.Web, :controller

  alias BNote.Foo

  plug :scrub_params, "foo" when action in [:create, :update]

  def index(conn, _params) do
    foo = Repo.all(Foo)
    render(conn, "index.html", foo: foo)
  end

  def new(conn, _params) do
    changeset = Foo.changeset(%Foo{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"foo" => foo_params}) do
    changeset = Foo.changeset(%Foo{}, foo_params)

    case Repo.insert(changeset) do
      {:ok, _foo} ->
        conn
        |> put_flash(:info, "Foo created successfully.")
        |> redirect(to: foo_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    foo = Repo.get!(Foo, id)
    render(conn, "show.html", foo: foo)
  end

  def edit(conn, %{"id" => id}) do
    foo = Repo.get!(Foo, id)
    changeset = Foo.changeset(foo)
    render(conn, "edit.html", foo: foo, changeset: changeset)
  end

  def update(conn, %{"id" => id, "foo" => foo_params}) do
    foo = Repo.get!(Foo, id)
    changeset = Foo.changeset(foo, foo_params)

    case Repo.update(changeset) do
      {:ok, foo} ->
        conn
        |> put_flash(:info, "Foo updated successfully.")
        |> redirect(to: foo_path(conn, :show, foo))
      {:error, changeset} ->
        render(conn, "edit.html", foo: foo, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    foo = Repo.get!(Foo, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(foo)

    conn
    |> put_flash(:info, "Foo deleted successfully.")
    |> redirect(to: foo_path(conn, :index))
  end
end
