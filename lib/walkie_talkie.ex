defmodule WalkieTalkie do
  alias WalkieTalkie.Accounts

  defdelegate create_account(params), to: Accounts, as: :create_account
end
