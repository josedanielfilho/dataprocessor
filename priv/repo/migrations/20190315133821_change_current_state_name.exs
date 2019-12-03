defmodule DataProcessorBackend.Repo.Migrations.ChangeCurrentStateName do
  use Ecto.Migration

  def change do
    rename table(:processing_jobs), :current_state, to: :job_state
  end
end
