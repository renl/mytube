defmodule MytubeWeb.AuthController do
  use MytubeWeb, :controller
  plug Ueberauth

  alias Mytube.User
  alias Mytube.Repo

  def delete(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: page_path(conn, :index))
  end
  
  def create(conn, changeset) do
    case insert_or_update_user(changeset) do
      {:ok, user} ->
	conn
	|> put_flash(:info, "Thank you for signing in!")
	|> put_session(:user_id, user.id)
	|> redirect(to: video_path(conn, :index))
      {:error, _reason} ->
	conn
	|> put_flash(:error, "Error signing in")
	|> redirect(to: page_path(conn, :index))
    end
  end

  def insert_or_update_user(changeset) do
    case Repo.get_by(User, email: changeset.changes.email) do
      nil ->
	Repo.insert(changeset)
      user ->
	{:ok, user}
    end
  end
  
  def new(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    # IO.inspect conn.assigns
    user_params = %{
      token: auth.credentials.token,
      first_name: auth.info.first_name,
      last_name: auth.info.last_name,
      email: auth.info.email,
      provider: "google"
    }
    changeset = User.changeset(%User{}, user_params)

    create(conn, changeset)
  end
  
end
