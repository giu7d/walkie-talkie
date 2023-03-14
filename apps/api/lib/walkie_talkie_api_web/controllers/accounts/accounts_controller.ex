defmodule WalkieTalkieWeb.AccountsController do
  use WalkieTalkieWeb, :controller

  alias WalkieTalkie.Accounts.Account
  alias WalkieTalkieWeb.Validator

  action_fallback WalkieTalkieWeb.FallbackController

  @create_account_params %{
    name: [type: :string],
    email: [type: :string]
  }
  def create_account(conn, params) do
    with {:ok, params} <- Validator.cast(params, @create_account_params),
         {:ok, %Account{} = account} <- WalkieTalkie.create_account(params) do
      conn
      |> put_status(:created)
      |> render("create_account.json", %{account: account})
    end
  end
end
