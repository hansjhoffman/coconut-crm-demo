defmodule CoconutWeb.CountryControllerTest do
  use CoconutWeb.ConnCase

  test "List countries", %{conn: conn} do
    response = get(conn, Routes.country_path(conn, :index))

    assert json_response(response, 200)
    refute %{"data" => [], "status" => "ok"} == response
  end
end
