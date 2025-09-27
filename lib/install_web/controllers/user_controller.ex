
defmodule InstallWeb.UserController do
  use InstallWeb, :controller
  alias Install.User
  alias Install.Repo
  alias Install.Token
  alias Pbkdf2

  def init(default), do: default

  def signup(conn, params) do
    user_params = Map.take(params, ["email", "password_input", "name"])
    changeset = User.changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> json(%{message: "User created successfully", user_id: user.id})

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: changeset})
    end
  end

  def login(conn, %{"email" => email, "password" => password}) do
    case Repo.get_by(User, email: email) do
      nil ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Invalid email or password"})

      user ->
        if Pbkdf2.verify_pass(password, user.password) do
          {:ok, token} = Token.generate_and_sign(%{"user_id" => user.id})
          conn
          |> put_status(:ok)
          |> json(%{message: "Login successful", token: token})
        else
          conn
          |> put_status(:unauthorized)
          |> json(%{error: "Invalid email or password"})
        end
    end
  end

  def delete(conn, %{"id" => id} = _params) do
    user = Repo.get!(User, id)

    case Repo.delete(user) do
      {:ok, _struct} -> json(conn, %{message: "User deleted Successfully"})
      {:error, changeset} -> json(conn, %{error: changeset})
    end
  end
end
