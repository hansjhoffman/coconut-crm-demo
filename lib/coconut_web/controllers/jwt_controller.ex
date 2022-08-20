defmodule CoconutWeb.JwtController do
  use CoconutWeb, :controller

  # private_key = Application.get_env(:flatfile_secret_1)

  def create(conn, %{"embedId" => embed_id}) do
    user = %{id: "", email: ""}
    org = %{name: "Coconut Shop"}
    env = %{}

    signed_token =
      Coconut.Jwt.create("private_key", %{
        user: user,
        org: org,
        env: env,
        embed_id: embed_id
      })

    render(conn, "create.json", token: signed_token)
  end
end
