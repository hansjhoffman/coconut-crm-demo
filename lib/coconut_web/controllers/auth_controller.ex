defmodule CoconutWeb.AuthController do
  use CoconutWeb, :controller

  plug Ueberauth

  alias Coconut.Accounts
  alias Ueberauth.Strategy.Helpers

  def index(conn, _params) do
    conn
    |> render("index.html")
  end

  def request(conn, _params) do
    callback_url = Helpers.callback_url(conn)

    conn
    |> render("request.html", callback_url: callback_url)
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> clear_session()
    |> redirect(to: Routes.auth_path(conn, :index))
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: Routes.auth_path(conn, :index))
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case Accounts.find_or_create(auth) do
      {:ok, user} ->
        conn
        |> put_session(:current_user, user)
        |> configure_session(renew: true)
        |> redirect(to: "/")

      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.auth_path(conn, :index))
    end
  end
end
