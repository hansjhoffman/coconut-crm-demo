defmodule CoconutWeb.HealthCheckController do
  use CoconutWeb, :controller

  def index(conn, _params) do
    response = %{
      status: "pass",
      version: to_string(Application.spec(:coconut, :vsn))
    }

    render(conn, "index.json", response: response)
  end
end
