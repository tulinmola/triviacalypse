defmodule TriviacalypseWeb.PageController do
  use TriviacalypseWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
