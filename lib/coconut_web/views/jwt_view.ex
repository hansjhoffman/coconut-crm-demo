defmodule CoconutWeb.JwtView do
  use CoconutWeb, :view

  def render("create.json", %{token: token}) do
    %{token: token}
  end
end
