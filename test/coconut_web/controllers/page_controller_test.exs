defmodule CoconutWeb.PageControllerTest do
  use CoconutWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, Routes.page_path(conn, :index))

    assert html_response(conn, 200) =~ "Home"
  end
end
