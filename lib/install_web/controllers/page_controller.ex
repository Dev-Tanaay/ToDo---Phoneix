defmodule InstallWeb.PageController do
  use InstallWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
