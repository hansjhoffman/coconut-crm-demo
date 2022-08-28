defmodule CoconutWeb.LeadController do
  use CoconutWeb, :controller

  def index(conn, _params) do
    # current_user = conn.assigns[:current_user]
    leads = []

    render(conn, "index.html", leads: leads)
  end
end
