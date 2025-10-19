defmodule ExdrawWeb.AuthController do
  alias Exdraw.Accounts
  use ExdrawWeb, :controller
  plug Ueberauth

  def callback(%{assigns: %{ueberauth_failure: %Ueberauth.Failure{}}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate")
    |> redirect(to: ~p"/")
  end

  def callback(%{assigns: %{ueberauth_auth: %Ueberauth.Auth{} = auth}} = conn, _params) do
    case Accounts.upsert_user_from_oauth(auth) do
      {:ok, user} ->
        conn
        |> put_session(:user_return_to, ~p"/home")
        |> ExdrawWeb.UserAuth.log_in_user(user)

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Unable to authenticate with GitHub")
        |> redirect(to: ~p"/users/log-in")
    end
  end
end
