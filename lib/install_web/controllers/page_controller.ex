defmodule InstallWeb.PageController do
  use InstallWeb, :controller

  def index(conn, _params) do
    json(conn,%{message: "Hello World"})
  end
end
