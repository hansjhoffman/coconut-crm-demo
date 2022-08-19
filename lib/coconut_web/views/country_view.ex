defmodule CoconutWeb.CountryView do
  use CoconutWeb, :view

  def render("index.json", %{countries: countries}) do
    %{status: "ok", data: countries}
  end
end
