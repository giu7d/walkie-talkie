defmodule WalkieTalkieWeb.AccountsJSON do
  alias WalkieTalkie.Accounts.Account

  def create_account(%{account: %Account{} = account}) do
    %{
      id: account.id,
      name: account.name,
      email: account.email,
      inserted_at: account.inserted_at,
      updated_at: account.updated_at
    }
  end
end
