defmodule DataProcessorBackend.Repo do
  use Ecto.Repo,
    otp_app: :data_processor_backend,
    adapter: Ecto.Adapters.Postgres
end
