defmodule CoconutWeb.UserAuth do
  @moduledoc false

  import Plug.Conn
  import Phoenix.Controller

  alias CoconutWeb.Router.Helpers, as: Routes

  @doc """
  Authenticates the user by looking into the session.
  """
  def fetch_current_user(conn, _opts) do
    user =
      conn
      |> get_session(:current_user)

    conn
    |> assign(:current_user, user)
  end

  @doc """
  Allow authenticated user to continue or redirect if unauthenticated.
  """
  def ensure_authenticated_user(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
    else
      conn
      |> put_flash(:error, "You must log in to access this page.")
      |> maybe_store_return_to()
      |> redirect(to: Routes.auth_path(conn, :index))
      |> halt()
    end
  end

  defp maybe_store_return_to(%{method: "GET"} = conn) do
    conn
    |> put_session(:user_return_to, current_path(conn))
  end

  defp maybe_store_return_to(conn), do: conn
end
