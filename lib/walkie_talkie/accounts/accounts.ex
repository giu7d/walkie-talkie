defmodule WalkieTalkie.Accounts do
  alias WalkieTalkie.Repo
  alias WalkieTalkie.Accounts.Account

  def create_account(params) do
    params
    |> Account.changeset()
    |> Repo.insert()
  end
end
