defmodule MytubeWeb.PageControllerTest do
  use MytubeWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    # assert html_response(conn, 200) =~ "Welcome to My Tube!"
    assert html_response(conn, 200) =~ "Welcome to My Tube!"
  end
end
