defmodule CoconutWeb.HealthCheckView do
  use CoconutWeb, :view

  def render("index.json", %{version: version}) do
    %{status: "pass", version: version}
  end
end
