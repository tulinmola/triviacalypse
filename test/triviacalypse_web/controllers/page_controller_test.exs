defmodule TriviacalypseWeb.PageControllerTest do
  use TriviacalypseWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Triviacalypse"
  end
end
