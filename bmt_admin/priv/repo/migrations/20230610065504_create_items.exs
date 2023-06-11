defmodule BmtAdmin.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :name, :string
      add :password, :string
      add :desc, :string

      timestamps()
    end
  end
end
