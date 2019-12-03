# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     DataProcessorBackend.Repo.insert!(%DataProcessorBackend.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias DataProcessorBackend.Repo
alias DataProcessorBackend.InterSCity.JobScript
alias DataProcessorBackend.InterSCity.JobTemplate
alias DataProcessorBackend.InterSCity.ProcessingJob
alias DataProcessorBackend.InterSCity.ScriptSamples.Kmeans
alias DataProcessorBackend.InterSCity.ScriptSamples.CollectorSource
alias DataProcessorBackend.InterSCity.ScriptSamples.Schemas

Repo.delete_all ProcessingJob
Repo.delete_all JobTemplate
Repo.delete_all JobScript

# Schemas

# Collector Extraction
# attrs = %{
#   title: "Extract Collector",
#   language: CollectorSource.language,
#   code: CollectorSource.code,
#   defined_at_runtime: false,
#   path: "collectorsource.py"}
# {:ok, script} = attrs |> JobScript.create()
#
# {:ok, template} =
#   %{title: CollectorSource.example_title, user_params: CollectorSource.example_user_params}
#   |> JobTemplate.create(script)

# KMeans
# attrs = %{
#   title: "KMeans",
#   language: Kmeans.language,
#   code: Kmeans.code,
#   defined_at_runtime: false,
#   path: "kmeans.py"}
# {:ok, script} = attrs |> JobScript.create()
#
# {:ok, template} =
#   %{title: Kmeans.example_title, user_params: Kmeans.example_user_params}
#   |> JobTemplate.create(script)

# Query SQL
# attrs = %{
#   title: "Query SQL",
#   language: "python",
#   code: "sorry",
#   defined_at_runtime: true,
#   code_strategy: "Elixir.DataProcessorBackend.InterSCity.ScriptSamples.SqlQuery",
#   path: "sql_query.py"}
# {:ok, script} = attrs |> JobScript.create()
