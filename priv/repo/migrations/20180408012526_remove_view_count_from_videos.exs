defmodule Mytube.Repo.Migrations.RemoveViewCountFromVideos do
  use Ecto.Migration

  def change do
    alter table(:videos) do
      remove :view_count
    end
  end
end
