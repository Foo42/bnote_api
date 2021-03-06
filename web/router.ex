defmodule BNote.Router do
  use BNote.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BNote do
    pipe_through :browser # Use the default browser stack

    get "/", NoteController, :index

    scope "/notes" do
      get "/new", NoteController, :new
      post "/new", NoteController, :create
    end
  end

  scope "/notes", BNote do
    pipe_through :api
    get "/", NoteController, :get_notes

    get "/:note_id", NoteController, :get_note_by_id

    scope "/for"  do
      get "/:book", NoteController, :get_notes
      get "/:book/:chapter", NoteController, :get_notes
      get "/:book/:chapter/:verse", NoteController, :get_notes
    end

    post "/", NoteController, :create
  end

  # Other scopes may use custom stacks.
  # scope "/api", BNote do
  #   pipe_through :api
  # end
end
