defmodule DataProcessorBackend.Repo.Migrations.ChangeLogFieldType do
  use Ecto.Migration

  def change do
    alter table(:processing_jobs) do
      modify :log, :text
    end
  end
end
