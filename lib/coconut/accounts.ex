defmodule Coconut.Accounts do
  @moduledoc """
  The Accounts context.
  """

  require Logger

  import Ecto.Query, warn: false

  alias Coconut.Accounts.User
  alias Coconut.Repo

  ## Database getters

  @doc """
  Gets a user by email.

  ## Examples

      iex> get_user_by_email("foo@example.com")
      %User{}

      iex> get_user_by_email("unknown@example.com")
      nil

  """
  def get_user_by_email(email) when is_binary(email) do
    Repo.get_by(User, email: email)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id) do
    Repo.get!(User, id)
  end

  ## User registration

  @doc """
  Registers a user.

  ## Examples

      iex> register_user(%{field: value})
      {:ok, %User{}}

      iex> register_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def register_user(attrs) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  ## Ueberauth

  @doc """
  Attempts to find an existing user or creates a new user.

  ## Examples

      iex> find_or_create(%Ueberauth.Auth{})
      {:ok, %User{}}

      iex> find_or_create(%Ueberauth.Auth{})
      {:error, :msg}

  """
  def find_or_create(%Ueberauth.Auth{provider: :google} = auth) do
    with email <- email_from_auth(auth),
         %User{} = existing_user <- get_user_by_email(email) do
      {:ok, existing_user}
    else
      nil ->
        case register_user(basic_info(auth)) do
          {:ok, %User{} = new_user} ->
            {:ok, new_user}

          {:error, %Ecto.Changeset{}} ->
            {:error, :oauth_login_failure}
        end
    end
  end

  defp basic_info(auth) do
    %{
      uid: auth.uid,
      email: email_from_auth(auth),
      name: name_from_auth(auth),
      avatar: avatar_from_auth(auth)
    }
  end

  defp email_from_auth(%{info: %{email: email}}), do: email

  defp email_from_auth(auth) do
    Logger.warn("#{auth.provider} needs to find an email!")
    Logger.debug(Jason.encode!(auth))
    nil
  end

  defp avatar_from_auth(%{info: %{image: image}}), do: image

  defp avatar_from_auth(auth) do
    Logger.warn("#{auth.provider} needs to find an avatar URL!")
    Logger.debug(Jason.encode!(auth))
    nil
  end

  defp name_from_auth(auth) do
    if auth.info.name do
      auth.info.name
    else
      name =
        [auth.info.first_name, auth.info.last_name]
        |> Enum.filter(&(&1 != nil and &1 != ""))

      if Enum.empty?(name) do
        auth.info.nickname
      else
        Enum.join(name, " ")
      end
    end
  end
end
