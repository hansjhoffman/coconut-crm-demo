defmodule CoconutWeb.LoginController do
  use CoconutWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
