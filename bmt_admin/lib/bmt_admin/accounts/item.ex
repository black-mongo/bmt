defmodule BmtAdmin.Accounts.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field :desc, :string
    field :name, :string
    field :password, :string

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:name, :password, :desc])
    |> validate_required([:name, :password])
  end
end
