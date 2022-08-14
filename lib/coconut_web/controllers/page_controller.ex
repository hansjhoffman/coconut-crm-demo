defmodule CoconutWeb.PageController do
  use CoconutWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
