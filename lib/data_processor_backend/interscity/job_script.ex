defmodule DataProcessorBackend.InterSCity.JobScript do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  use DataProcessorBackend.InterSCity.Model

  alias DataProcessorBackend.Repo
  alias DataProcessorBackend.InterSCity.JobScript
  alias DataProcessorBackend.InterSCity.ScriptSamples.CodeGen
  alias DataProcessorBackend.InterSCity.ScriptSamples.SqlQuery


  schema "job_scripts" do
    field(:title, :string)
    field(:language, :string)
    field(:code, :string)
    field(:path, :string)
    field(:defined_at_runtime, :boolean)
    field(:code_strategy, :string)

    timestamps()
  end

  @attrs [
    :title, :language, :code, :path,
    :defined_at_runtime, :code_strategy
  ]
  @required_attrs [
    :title, :language, :code, :path,
    :defined_at_runtime, :code_strategy
  ]

  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @attrs)
    |> validate_required(@required_attrs)
    |> mount_code()
  end

  def mount_code(changeset=%Ecto.Changeset{valid?: true}) do
    runtime = get_field(changeset, :defined_at_runtime, false)
    code = get_field(changeset, :code)
    module_name = get_field(changeset, :code_strategy)

    newcode = case runtime do
      true ->
        :"#{module_name}" |> apply(:gen_code, [])
      _ ->
        code
    end

    change(changeset, %{code: newcode})
  end

  def mount_code(changeset),
    do: changeset

  def create(attrs) do
    %JobScript{}
    |> JobScript.changeset(attrs)
    |> Repo.insert()
  end

  def all() do
    fields_to_use = [:title, :language, :code, :path, :id]
    (from u in JobScript, select: ^fields_to_use)
    |> Repo.all
  end
end
