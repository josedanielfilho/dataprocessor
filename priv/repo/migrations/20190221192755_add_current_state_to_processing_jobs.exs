defmodule DataProcessorBackend.Repo.Migrations.AddCurrentStateToProcessingJobs do
  use Ecto.Migration

  def change do
    alter table(:processing_jobs) do
      add :current_state, :string, default: "unknown"
    end
  end
end
