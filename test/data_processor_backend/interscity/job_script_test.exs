defmodule DataProcessorBackend.InterSCity.JobScriptTest do
  use DataProcessorBackend.DataCase

  import DataProcessorBackend.Factory
  alias DataProcessorBackend.InterSCity.JobScript

  describe ":changeset" do
    test "correctly mounts a pre_signed code" do
      params = params_for(:job_script)
      changeset = JobScript.changeset(%JobScript{}, params)
      %Ecto.Changeset{valid?: true, changes: %{code: code, defined_at_runtime: runtime}}=changeset
      assert code=="blalb"
      assert runtime==:false
    end

    test "correctly mounts code at runtime" do
      params = params_for(:job_script) |> Map.put(:defined_at_runtime, true) |> Map.put(:title, "MyNiceScript")
      assert params.defined_at_runtime==true
      assert params.code_strategy=="Elixir.DataProcessorBackend.InterSCity.ScriptSamples.SqlQuery"
      changeset = JobScript.changeset(%JobScript{}, params)
      %Ecto.Changeset{valid?: true, changes: %{code: code}}=changeset
      assert code=~"spark.sql"
    end
  end
end
