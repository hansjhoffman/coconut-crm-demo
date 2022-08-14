defmodule CoconutWeb.PageController do
  use CoconutWeb, :controller

  # private_key = Application.get_env(:flatfile_secret_1)

  def index(conn, _params) do
    signed_token = Coconut.Jwt.create("private_key", "embed_id", "foo@bar.com")

    render(conn, "index.html", token: signed_token)
  end
end
