defmodule DataProcessorBackendWeb.ScriptStrategyController do
  use DataProcessorBackendWeb, :controller

  @available_strategies [
    %{
      strategy_name: "Elixir.DataProcessorBackend.InterSCity.ScriptSamples.SqlQuery",
      id: 1
    },
    %{
      strategy_name: "Elixir.DataProcessorBackend.InterSCity.ScriptSamples.PandasDataFrame",
      id: 2
    },
    %{
      strategy_name: "Elixir.DataProcessorBackend.InterSCity.ScriptSamples.Kmeans",
      id: 3
    }
  ]

  def index(conn, _params) do
    conn
    |> render("index.json-api", %{data: @available_strategies})
  end

  def find_script(id) do
    Enum.find(@available_strategies, fn x -> x[:id] == id end)
  end

  def show(conn, %{"id" => id}) do
    script = find_script(id)
    IO.inspect script
    conn
    |> render("show.json", %{data: script})
  end
end
