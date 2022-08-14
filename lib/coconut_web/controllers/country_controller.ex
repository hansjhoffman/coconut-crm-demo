defmodule CoconutWeb.CountryController do
  use CoconutWeb, :controller

  @countries [
    %{name: "United States", country_code: "US"}
  ]

  def index(conn, _params) do
    response = %{
      status: "ok",
      data: @countries
    }

    render(conn, "index.json", response: response)
  end
end
