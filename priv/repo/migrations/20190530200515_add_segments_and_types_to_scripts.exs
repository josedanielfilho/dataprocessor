defmodule DataProcessorBackend.Repo.Migrations.AddSegmentsAndTypesToScripts do
  use Ecto.Migration

  def change do
    alter table(:job_scripts) do
      add :defined_at_runtime, :boolean, default: false
      add :code_strategy, :string, default: "DataProcessorBackend.InterSCity.ScriptSamples.CodeGen"
    end
  end
end
