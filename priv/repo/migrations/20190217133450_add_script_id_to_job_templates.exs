defmodule DataProcessorBackend.Repo.Migrations.AddScriptIdToJobTemplates do
  use Ecto.Migration

  def change do
    alter table(:job_templates) do
      add :job_script_id, references(:job_scripts), null: false
    end
  end
end
