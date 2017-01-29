defmodule ETagTracker.Visitor do
  use ETagTracker.Web, :model

  schema "visitors" do
    field :token, :string
    field :visits, :integer

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:token, :visits])
    |> validate_required([:token, :visits])
  end
end
