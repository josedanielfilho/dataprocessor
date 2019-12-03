defmodule DataProcessorBackend.InterSCity.Model do
  defmacro __using__(opts) do
    quote do
      def all do
        __MODULE__
        |> order_by(desc: :inserted_at)
        |> DataProcessorBackend.Repo.all
      end

      def find(id),
        do: DataProcessorBackend.Repo.get(__MODULE__, id)
      def find!(id),
        do: DataProcessorBackend.Repo.get!(__MODULE__, id)

      def empty() do
        __MODULE__.__struct__
      end

      def count() do
        DataProcessorBackend.Repo.aggregate(from(p in __MODULE__), :count, :id)
      end
    end
  end
end
