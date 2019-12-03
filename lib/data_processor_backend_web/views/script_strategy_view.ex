defmodule DataProcessorBackendWeb.ScriptStrategyView do
  use DataProcessorBackendWeb, :view
  use JaSerializer.PhoenixView

  attributes [:strategy_name]
end
