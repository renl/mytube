defmodule Mytube.Repo.Migrations.AddNotesColToVideos do
  use Ecto.Migration

  def change do
    alter table(:videos) do
      add :notes, :text
    end
  end
end
