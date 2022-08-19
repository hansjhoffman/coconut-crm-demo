defmodule CoconutWeb.LeadControllerTest do
  use CoconutWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, Routes.lead_path(conn, :index))

    assert html_response(conn, 200) =~ "Home"
  end
end
