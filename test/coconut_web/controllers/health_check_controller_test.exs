defmodule CoconutWeb.HealthCheckControllerTest do
  use CoconutWeb.ConnCase

  test "Health check", %{conn: conn} do
    response = get(conn, Routes.health_check_path(conn, :index))

    expected = %{
      "status" => "pass",
      "version" => to_string(Application.spec(:coconut, :vsn))
    }

    assert expected == json_response(response, 200)
  end
end
