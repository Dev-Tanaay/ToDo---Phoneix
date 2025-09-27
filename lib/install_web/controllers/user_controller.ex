defmodule InstallWeb.UserController do
  use InstallWeb, :controller
  alias Install.User
  alias Install.Repo
  alias Pbkdf2

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

  def login(conn, params) do
    user_params = Map.take(params, ["email", "password"])
    user = Repo.get_by(User, email: user_params["email"])

    cond do
      user && Pbkdf2.verify_pass(user_params["password"], user.password) ->
        conn
        |> put_status(:ok)
        |> json(%{message: "Login successful", user_id: user.id})

      true ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Invalid email or password"})
    end
  end

  def delete(conn, %{"id" => id} = _params) do
    user = Repo.get!(User, id)

    case Repo.delete(user) do
      {:ok, struct} -> json(conn, %{message: "User deleted Successfully"})
      {:error, changeset} -> json(conn, %{error: changeset})
    end
  end
end
