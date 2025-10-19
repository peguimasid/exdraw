defmodule ExdrawWeb.AuthController do
  use ExdrawWeb, :controller
  plug Ueberauth

  def callback(%{assigns: %{ueberauth_failure: %Ueberauth.Failure{}}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate")
    |> redirect(to: ~p"/")
  end

  def callback(%{assigns: %{ueberauth_auth: %Ueberauth.Auth{} = auth}} = conn, _params) do
    # You will have to implement this function that inserts into the database
    # user = MyApp.Accounts.create_user_from_ueberauth!(auth)

    IO.inspect(auth, label: "THIS IS WHAT WE GOT")

    # If you are using mix phx.gen.auth, you can use it to login
    # ExdrawWeb.UserAuth.log_in_user(conn, user)

    # If you are not using mix phx.gen.auth, store the user in the session
    conn
    # |> renew_session()
    # |> put_session(:user_id, user.id)
    |> redirect(to: ~p"/")
  end
end
