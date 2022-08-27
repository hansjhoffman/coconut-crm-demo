defmodule Coconut.Jwt do
  @moduledoc """
  Generate JWTs for Flatfile importer.
  """

  @max_age 60 * 60

  def create(meta, params) do
    jwk = JOSE.JWK.from_oct(meta.private_key)

    jws = %{
      "alg" => "HS256",
      "typ" => "JWT"
    }

    jwt = %{
      "iss" => "Coconut Shop",
      "exp" =>
        DateTime.utc_now()
        |> DateTime.add(@max_age, :second)
        |> DateTime.to_unix(),
      "user" => params.user,
      "org" => params.org,
      "env" => params.env,
      "embed" => meta.embed_id
    }

    JOSE.JWT.sign(jwk, jws, jwt) |> JOSE.JWS.compact() |> elem(1)
  end
end
