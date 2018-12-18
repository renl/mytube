defmodule Mytube.Repo.Migrations.RemoveVideoUniqueIndexCreateNormalIndex do
  use Ecto.Migration

  def change do
    drop unique_index(:videos, [:video_id]) 
    create index(:videos, [:video_id])    
  end
end
