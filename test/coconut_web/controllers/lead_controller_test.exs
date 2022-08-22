defmodule CoconutWeb.LeadControllerTest do
  use CoconutWeb.ConnCase, async: true

  import Coconut.Factory

  alias Coconut.Accounts.User

  describe "Leads Demo" do
    test "redirects when unauthenticated", %{conn: conn} do
      conn = get(conn, Routes.lead_path(conn, :index))

      refute get_session(conn, :current_user)
      assert redirected_to(conn) == Routes.auth_path(conn, :index)
    end

    test "allows access for authenticated user", %{conn: conn} do
      user = insert(:user)

      conn =
        conn
        |> with_user(user)
        |> get(Routes.lead_path(conn, :index))

      assert html_response(conn, 200) =~ "Home"
    end
  end

  defp with_user(conn, %User{} = user) do
    conn
    |> Plug.Test.init_test_session(current_user: user)
  end
end
