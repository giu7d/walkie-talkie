defmodule WalkieTalkieWeb.FallbackController do
  use WalkieTalkieWeb, :controller

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(json: HelloWeb.ErrorJSON)
    |> render(:"404")
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(403)
    |> put_view(json: HelloWeb.ErrorJSON)
    |> render(:"403")
  end
end
