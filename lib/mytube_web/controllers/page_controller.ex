defmodule MytubeWeb.PageController do
  use MytubeWeb, :controller

  def index(conn, _params) do
    conn
    |> put_flash(:info, "Welcome.")
    |> render("index.html")
  end
end
