defmodule CoconutWeb.PageController do
  use CoconutWeb, :controller

  def index(conn, _params) do
    token = "asdf"

    render(conn, "index.html", token: token)
  end
end
