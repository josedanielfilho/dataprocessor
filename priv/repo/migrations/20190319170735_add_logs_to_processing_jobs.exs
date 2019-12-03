defmodule DataProcessorBackend.Repo.Migrations.AddLogsToProcessingJobs do
  use Ecto.Migration

  def change do
    alter table(:processing_jobs) do
      add :log, :string, default: ""
    end
  end
end
