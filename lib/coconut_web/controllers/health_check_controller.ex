defmodule CoconutWeb.HealthCheckController do
  use CoconutWeb, :controller

  def index(conn, _params) do
    version = to_string(Application.spec(:coconut, :vsn))

    render(conn, "index.json", version: version)
  end
end
