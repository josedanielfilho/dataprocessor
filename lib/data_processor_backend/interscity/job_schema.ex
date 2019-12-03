defmodule DataProcessorBackend.InterSCity.JobSchema do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  use DataProcessorBackend.InterSCity.Model

  alias DataProcessorBackend.Repo
  alias DataProcessorBackend.InterSCity.JobScript
  alias DataProcessorBackend.InterSCity.JobSchema

  schema "job_schemas" do
    field(:title, :string)
    field(:interscity_schema, :map,
      default: %{ }
    )

    timestamps()
  end

  def changeset(struct, attrs) do
    struct
    |> cast(attrs, [:title, :interscity_schema])
    |> validate_required([:title, :interscity_schema])
  end

  def create(attrs) do
    %JobSchema{}
    |> JobSchema.changeset(attrs)
    |> Repo.insert()
  end

  def all() do
    fields_to_use = [:title, :interscity_schema]
    (from u in JobSchema, select: ^fields_to_use)
    |> Repo.all
  end
end
