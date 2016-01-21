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

    get "/", PageController, :index
  end

  scope "/notes", BNote do
    pipe_through :api
    get "/", NoteController, :get_notes
    get "/:book", NoteController, :get_notes
    get "/:book/:chapter", NoteController, :get_notes
    get "/:book/:chapter/:verse", NoteController, :get_notes
  end

  # Other scopes may use custom stacks.
  # scope "/api", BNote do
  #   pipe_through :api
  # end
end
