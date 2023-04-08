defmodule WalkieTalkie.Accounts.Account do
  use WalkieTalkie.Schema

  import Ecto.Changeset

  @required_fields [
    :name,
    :email
  ]

  schema "accounts" do
    field(:name, :string)
    field(:email, :string)

    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> changeset(params)
  end

  def changeset(struct, params) do
    struct
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
  end
end
