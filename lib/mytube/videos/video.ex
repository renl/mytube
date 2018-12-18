defmodule Mytube.Videos.Video do
  use Ecto.Schema
  import Ecto.Changeset


  schema "videos" do
    field :duration, :string
    field :thumbnail, :string
    field :title, :string
    field :video_id, :string
    field :notes, :string
    belongs_to :user, Mytube.User
    
    timestamps()
  end

  @doc false
  def changeset(video, attrs) do
    video
    |> cast(attrs, [:video_id, :title, :duration, :thumbnail, :notes])
    |> validate_required([:video_id, :title, :duration, :thumbnail])
  end
end
