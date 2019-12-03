defmodule DataProcessorBackend.InterSCity.JobTemplateTest do
  use DataProcessorBackend.DataCase

  import DataProcessorBackend.Factory
  alias DataProcessorBackend.InterSCity.JobTemplate

  describe ":count" do
    test "correctly counts templates" do
      assert JobTemplate.count==0
      insert(:job_template)
      assert JobTemplate.count==1
      insert(:job_template)
      assert JobTemplate.count==2
    end
  end

  describe ":clone" do
    test "correctly clone templates" do
      assert JobTemplate.count==0
      template = insert(:job_template)
      assert JobTemplate.count==1
      clone1 = JobTemplate.clone(template)
      assert JobTemplate.count==2
      clone1_refetch = Repo.get!(JobTemplate, clone1.id)
      template_refetch = Repo.get!(JobTemplate, template.id)

      assert clone1_refetch.title==template_refetch.title
      assert clone1_refetch.user_params==template_refetch.user_params
      assert clone1_refetch.job_script==template_refetch.job_script
      assert clone1_refetch.publish_strategy==template_refetch.publish_strategy

      clone2 = JobTemplate.clone(template)
      assert JobTemplate.count==3
      assert clone2.title==template.title
      assert clone2.user_params==template.user_params
    end
  end

  describe ":interscity_schema" do
    test "correctly returns interscity_schema" do
      template = insert(:job_template)
      sch = Map.get(template.user_params, :schema)
      assert JobTemplate.interscity_schema(template)==sch
    end
  end

  describe ":compare_schemas" do
    test "correctly compare schemas of different types" do
      sch1 = %{temperature: "double"}
      sch2 = %{"temperature" => "double"}
      assert JobTemplate.compare_schemas(sch1, sch2)==true
    end
  end
end
