defmodule DataProcessorBackend.Repo.Migrations.CreateJobScript do
  use Ecto.Migration

  def change do
    create table(:job_scripts) do
      add :title, :string
      add :language, :string
      add :code, :text
      add :path, :string

      timestamps()
    end
  end
end
