defmodule CoconutWeb.LeadController do
  use CoconutWeb, :controller

  def index(conn, _params) do
    contacts = []

    render(conn, "index.html", contacts: contacts)
  end
end
