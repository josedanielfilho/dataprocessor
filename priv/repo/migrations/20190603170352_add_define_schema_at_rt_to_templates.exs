defmodule DataProcessorBackend.Repo.Migrations.AddDefineSchemaAtRtToTemplates do
  use Ecto.Migration
  import Ecto.Query

  def up do
    alter table(:job_templates) do
      add :define_schema_at_runtime, :boolean, default: false
    end

    flush()

    from(p in "job_templates",
      update: [set: [define_schema_at_runtime: false]])
    |> DataProcessorBackend.Repo.update_all([])
  end

  def down do
    alter table(:job_templates) do
      remove :define_schema_at_runtime
    end
  end
end
