defmodule DataProcessorBackend.Repo.Migrations.CreateJobTemplate do
  use Ecto.Migration

  def change do
    create table(:job_templates) do
      add :title, :string
      add :user_params, :map, null: false, default: %{
        schema: %{},
        functional_params: %{},
        interscity: %{}
      }
      add :publish_strategy, :map, null: false, default: %{
        format: "csv"
      }
      timestamps()
    end
  end
end
