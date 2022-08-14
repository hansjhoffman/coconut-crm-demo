defmodule CoconutWeb.CountryController do
  use CoconutWeb, :controller

  @countries [
    %{name: "United States", country_code: "US"}
  ]

  def index(conn, _params) do
    json(conn, %{status: "ok", data: @countries})
  end
end
