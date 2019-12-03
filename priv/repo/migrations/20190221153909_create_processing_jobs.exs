defmodule DataProcessorBackend.Repo.Migrations.CreateProcessingJobs do
  use Ecto.Migration

  def change do
    create table(:processing_jobs) do
      add :uuid, :string
      add :job_template_id, references(:job_templates)
      timestamps()
    end
  end
end
