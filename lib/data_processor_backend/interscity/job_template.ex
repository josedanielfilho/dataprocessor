defmodule DataProcessorBackend.InterSCity.JobTemplate do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  use DataProcessorBackend.InterSCity.Model
  alias DataProcessorBackend.InterSCity.JobTemplate
  alias DataProcessorBackend.InterSCity.ProcessingJob
  alias DataProcessorBackend.Repo
  alias DataProcessorBackend.InterSCity.JobScript
  alias DataProcessorBackend.InterSCity.ScriptSamples.DefaultStrategy

  schema "job_templates" do
    field(:title, :string)

    field(:user_params, :map,
      default: %{
        schema: %{},
        functional: %{},
        interscity: %{}
      }
    )

    field(:define_schema_at_runtime, :boolean, default: false)

    %{day: day, year: year, month: month, hour: hour, minute: minute, second: second} = DateTime.utc_now()

    field(:publish_strategy, :map, null: false, default: %{
      format: "parquet",
      path: "#{day}-#{month}-#{year}-#{hour}-#{minute}-#{second}"
    })

    belongs_to(:job_script, JobScript)

    timestamps()
  end

  def changeset(struct, attrs) do
    struct
    |> cast(attrs, [:title, :user_params, :publish_strategy, :id, :define_schema_at_runtime])
    |> assoc_constraint(:job_script)
    |> cast_assoc(:job_script, with: &JobScript.changeset/2)
    |> validate_required([:title, :define_schema_at_runtime])
  end

  def create(attrs, script) do
    %JobTemplate{job_script: script}
    |> JobTemplate.changeset(attrs)
    |> Repo.insert()
  end

  def clone(id) when is_integer(id),
    do: JobTemplate.find!(id) |> clone()
  def clone(id) when is_binary(id),
    do: String.to_integer(id) |> clone()
  def clone(%JobTemplate{}=template) do
    template
    |> Repo.preload(:job_script)
    |> clone_changeset(%{})
    |> Repo.insert!
  end

  def clone_changeset(%JobTemplate{}=template, attrs\\%{}) do
    title = Map.get(attrs, :title, template.title)
    user_params = Map.get(attrs, :user_params, template.user_params)
    publish_strategy = Map.get(attrs, :publish_strategy, template.publish_strategy)
    job_script = Map.get(attrs, :job_script, template.job_script) |> Map.from_struct()
    params = %{
      title: title,
      user_params: user_params,
      publish_strategy: publish_strategy,
      job_script: job_script
    }
    empty_changeset = JobTemplate.changeset(empty(), params)
  end

  def schedule_job(%JobTemplate{}=template) do
    ProcessingJob.create(template)
  end

  def interscity_schema(%JobTemplate{}=template) do
    # In Erlang/Elixir, a map with signature %{atom: value} is actually
    # different from a map with signature %{"atom" => value}
    # so here I handle both.
    user_params = template.user_params
    case Map.get(user_params, "schema") do
      nil -> Map.get(user_params, :schema)
      _ -> Map.get(user_params, "schema")
    end
  end

  def normalize_map(weird_map) do
    for {key, val} <- weird_map, into: %{} do
      cond do
        is_atom(key) -> {key, val}
        true -> {String.to_existing_atom(key), val}
      end
    end
  end

  def compare_schemas(sch1, sch2) when is_map(sch1) and is_map(sch2) do
    normalized_sch1 = normalize_map(sch1)
    normalized_sch2 = normalize_map(sch2)
    normalized_sch1 == normalized_sch2
  end

  def interscity_capability(template=%JobTemplate{}) do
    user_params = template.user_params
    interscity_params =
      case Map.get(user_params, "interscity") do
        nil -> Map.get(user_params, :interscity)
        _ -> Map.get(user_params, "interscity")
      end

    case Map.get(interscity_params, "capability") do
      nil -> Map.get(interscity_params, :capability)
      _ -> Map.get(interscity_params, "capability")
    end
  end

  def _reset_schema(template=%JobTemplate{}, nil),
    do: {:error, "invalid capability"}
  def _reset_schema(template=%JobTemplate{}, capability) do
    old_user_params = template.user_params
    new_schema = DefaultStrategy.discover_schema(capability)

    new_user_params =
      case Map.get(old_user_params, :schema) do
        nil ->
          Map.put(old_user_params, "schema", new_schema)
        _ ->
          Map.put(old_user_params, :schema, new_schema)
      end

    template
    |> JobTemplate.changeset(%{user_params: new_user_params})
    |> Repo.update()
  end

  def reset_schema(template=%JobTemplate{}) do
    capability = JobTemplate.interscity_capability(template)
    _reset_schema(template, capability)
  end
end
