defmodule Coconut.Jwt do
  @moduledoc """
  Generate JWTs for Flatfile importer.
  """

  def create(private_key, params) do
    jwk = %{
      "k" => private_key,
      "kty" => "oct"
    }

    jws = %{
      "alg" => "HS256",
      "typ" => "JWT"
    }

    jwt = %{
      "iss" => "Coconut Shop",
      "exp" =>
        DateTime.utc_now()
        |> DateTime.add(3600, :second)
        |> DateTime.to_unix(),
      "user" => params.user,
      "org" => params.org,
      "env" => params.env,
      "embed" => params.embed_id
    }

    JOSE.JWT.sign(jwk, jws, jwt) |> JOSE.JWS.compact() |> elem(1)
  end
end
