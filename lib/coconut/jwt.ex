defmodule Coconut.Jwt do
  @moduledoc """
  Generate JWTs for Flatfile importer.
  """

  # SDK v2
  # def create(private_key, %{user: user, org: org}) do
  #   jwk = %{"kty" => "oct", "k" => private_key}

  #   jws = %{"alg" => "HS256"}

  #   jwt = %{
  #     "iss" => "Coconut Shop",
  #     "exp" =>
  #       DateTime.utc_now()
  #       |> DateTime.add(1 * 60, :second)
  #       |> DateTime.to_unix(),
  #     "user" => %{"email" => user.email},
  #     "org" => %{"name" => org.name}
  #   }

  #   JOSE.JWT.sign(jwk, jws, jwt) |> JOSE.JWS.compact() |> elem(1)
  # end

  # SDK v1
  def create(private_key, embed_id, user_email) do
    jwk = %{"kty" => "oct", "k" => private_key}

    jws = %{"alg" => "HS256"}

    jwt = %{
      "iss" => "Coconut Shop",
      "exp" =>
        DateTime.utc_now()
        |> DateTime.add(3600, :second)
        |> DateTime.to_unix(),
      "sub" => %{"email" => user_email},
      "embed" => %{"name" => embed_id}
    }

    JOSE.JWT.sign(jwk, jws, jwt) |> JOSE.JWS.compact() |> elem(1)
  end
end
