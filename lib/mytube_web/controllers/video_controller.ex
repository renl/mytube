defmodule MytubeWeb.VideoController do
  use MytubeWeb, :controller

  alias Mytube.Videos
  alias Mytube.Videos.{Video, YoutubeData}

  plug :check_video_owner when action in [:delete, :update]
  
  defp check_video_owner(%{params: %{"id" => video_id}} = conn, _) do
    if Mytube.Repo.get(Video, video_id).user_id == conn.assigns.user.id do
      conn
    else
      conn
      |> put_flash(:error, "You cannot do that.")
      |> redirect(to: video_path(conn, :index))
      |> halt()
    end
  end

  def update(conn, %{"id" => id} = params) do
    video = Videos.get_video!(id)

    case Videos.update_video(video, params) do
      {:ok, video} ->
	conn
	|> json(%{})
      {:error, _} ->
	conn
	|> put_flash(:error, "You cannot do that")
	|>redirect(to: video_path(conn, :index))
    end
    
  end
  
  def index(conn, _params) do
    videos = Videos.list_videos()
    render(conn, "index.html", videos: videos)
  end

  def new(conn, _params) do
    changeset = Videos.change_video(%Video{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"video" => video_params}) do
    case YoutubeData.has_valid_regex?(video_params["video_id"]) do
      nil ->
    	changeset = Video.changeset(%Video{}, video_params)
    	conn
    	|> put_flash(:error, "Invalid YouTube URL")
    	|> render("new.html", changeset: changeset)
      [_url, video_id] ->
    	create_video(conn, video_id)
    end    
  end

  def create_video(conn, video_id) do
    case YoutubeData.create_video(conn.assigns.user, video_id) do
      {:ok, video} ->
	conn
	|> put_flash(:info, "Video created successfully.")
	|> redirect(to: video_path(conn, :show, video))
      {:error, _} ->
	conn
	|> put_flash(:error, "Video has already been created.")
	|> redirect(to: page_path(conn, :index))
    end
  end

  def show(conn, %{"id" => id}) do

    video = Videos.get_video!(id)
    changeset = Videos.change_video(video)
    render(conn, "show.html", video: video, changeset: changeset)
  end

  def delete(conn, %{"id" => id}) do
    video = Videos.get_video!(id)
    {:ok, _video} = Videos.delete_video(video)

    conn
    |> put_flash(:info, "Video deleted successfully.")
    |> redirect(to: video_path(conn, :index))
  end
end
