defmodule CoconutWeb.JwtController do
  use CoconutWeb, :controller

  @leads_embed "e0c14de2-27d9-4477-b6b7-8605085b8039"
  @products_embed "bafedf6e-0133-4155-bcbe-e4d017aaf8ec"

  def create(conn, %{"embedId" => embed_id}) do
    current_user = conn.assigns[:current_user]

    signed_token =
      Coconut.Jwt.create(
        %{
          private_key:
            case embed_id do
              @leads_embed ->
                Application.get_env(:coconut, :ff_leads_pk)

              @products_embed ->
                Application.get_env(:coconut, :ff_products_pk)

              _ ->
                "unknown"
            end,
          embed_id: embed_id
        },
        %{
          user: %{email: current_user.email},
          org: %{name: "Coconut Shop"},
          env: %{}
        }
      )

    render(conn, "create.json", token: signed_token)
  end
end
