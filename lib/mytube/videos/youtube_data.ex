defmodule Mytube.Videos.YoutubeData do
  alias Mytube.Videos.Video
  alias Mytube.Repo
  
  def has_valid_regex?(url) do
    Regex.run(~r/(?:youtube\.com\/\S*(?:(?:\/e(?:mbed))?\/|watch\?(?:\S*?&?v\=))|youtu\.be\/)([a-zA-Z0-9_-]{6,11})/, url)
  end

  def create_video(user, video_id) do

    user = Repo.preload user, :videos

    if Enum.any?(user.videos, fn(%Video{video_id: id}) -> video_id == id end) do 
      {:error, "You already have this video"}
    else
      video_data = get_api_response(video_id)
      |> parse_json()
      |> get_video_data()

      video_info = %{duration: video_data.contentDetails.duration,
		     thumbnail: video_data.snippet.thumbnails.high.url,
		     title: video_data.snippet.title,
		     video_id: video_data.id}

      changeset = user
      |> Ecto.build_assoc(:videos)
      |> Video.changeset(video_info)
      Repo.insert(changeset)	
    end    
  end

  def get_api_response(video_id) do
    api_response = HTTPoison.get!("https://www.googleapis.com/youtube/v3/videos?" <>
      "id=#{video_id}&" <>
      "key=#{System.get_env("YOUTUBE_API_KEY")}&" <>
      "part=snippet,contentDetails&" <>
      "fields=items(id,snippet(title,thumbnails(high))," <>
      "contentDetails(duration))")
    api_response.body
  end

  def parse_json(json) do
    Poison.decode!(json, keys: :atoms)    
  end

  def get_video_data(data) do
    hd(data.items)
  end
  
end
