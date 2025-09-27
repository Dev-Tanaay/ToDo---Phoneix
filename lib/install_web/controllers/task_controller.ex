defmodule InstallWeb.TaskController do
  use InstallWeb, :controller
  def list(conn,_params) do
    user = conn.assigns.current_user
    json(conn, %{
      id: user.id,
      email: user.email,
      name: user.name
    })
  end
end
