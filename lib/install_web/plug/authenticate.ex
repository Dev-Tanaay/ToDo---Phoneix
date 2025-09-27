defmodule InstallWeb.Plug.Authenticate do
  import Plug.Conn
  alias Install.Repo
  alias Install.User
  alias Install.Token

  def init(default), do: default

  def call(conn, _opts) do
    case get_req_header(conn, "authorization") do
      ["Bearer" <> token] ->
        verify_token(conn, token)

      _ ->
        conn
        |> send_resp(401, "UnAuthorized")
        |> halt()
    end
  end

  defp verify_token(conn, token) do
    case Token.verify_and_validate(token) do
      {:ok, %{"user_id" => user_id}} ->
        case Repo.get(User, user_id) do
          nil ->
            conn
            |> send_resp(401, "Unauthorized")
            |> halt()

          user ->
            assign(conn, :current_user, user)
        end

      {:error, _reason} ->
        conn
        |> send_resp(401, "Invalid token")
        |> halt()
    end
  end
end
