defmodule ETagTracker.Repo.Migrations.CreateVisitor do
  use Ecto.Migration

  def change do
    create table(:visitors) do
      add :token, :string
      add :visits, :integer

      timestamps()
    end

  end
end
