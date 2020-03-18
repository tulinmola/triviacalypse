defmodule TriviacalypseWeb.Router do
  use TriviacalypseWeb, :router

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

  scope "/", TriviacalypseWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/api", TriviacalypseWeb do
    pipe_through :api

    resources "/games", GameController, only: [:create] do
      resources "/start", StartController, only: [:create]
    end
  end
end
