defmodule ExdrawWeb.UserLive.ConfirmationTest do
  use ExdrawWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import Exdraw.AccountsFixtures

  alias Exdraw.Accounts

  setup do
    %{unconfirmed_user: unconfirmed_user_fixture(), confirmed_user: user_fixture()}
  end

  describe "Confirm user" do
    test "renders confirmation page for unconfirmed user", %{conn: conn, unconfirmed_user: user} do
      token =
        extract_user_token(fn url ->
          Accounts.deliver_login_instructions(user, url)
        end)

      {:ok, _lv, html} = live(conn, ~p"/users/log-in/#{token}")
      assert html =~ "Confirm and stay logged in"
    end

    test "renders login page for confirmed user", %{conn: conn, confirmed_user: user} do
      token =
        extract_user_token(fn url ->
          Accounts.deliver_login_instructions(user, url)
        end)

      {:ok, _lv, html} = live(conn, ~p"/users/log-in/#{token}")
      refute html =~ "Confirm my account"
      assert html =~ "Log in"
    end

    test "confirms the given token once", %{conn: conn, unconfirmed_user: user} do
      token =
        extract_user_token(fn url ->
          Accounts.deliver_login_instructions(user, url)
        end)

      {:ok, lv, _html} = live(conn, ~p"/users/log-in/#{token}")

      form = form(lv, "#confirmation_form", %{"user" => %{"token" => token}})
      render_submit(form)

      conn = follow_trigger_action(form, conn)

      assert Phoenix.Flash.get(conn.assigns.flash, :success) =~
               "User confirmed successfully"

      assert Accounts.get_user!(user.id).confirmed_at
      # we are logged in now
      assert get_session(conn, :user_token)
      assert redirected_to(conn) == ~p"/"

      # log out, new conn - token should be invalid now
      conn = build_conn()

      # Try to use the same token again - should be redirected with error
      assert {:error, {:live_redirect, %{to: "/users/log-in"}}} =
               live(conn, ~p"/users/log-in/#{token}")
    end

    test "logs confirmed user in without changing confirmed_at", %{
      conn: conn,
      confirmed_user: user
    } do
      token =
        extract_user_token(fn url ->
          Accounts.deliver_login_instructions(user, url)
        end)

      {:ok, lv, _html} = live(conn, ~p"/users/log-in/#{token}")

      form = form(lv, "#login_form", %{"user" => %{"token" => token}})
      render_submit(form)

      conn = follow_trigger_action(form, conn)

      assert Phoenix.Flash.get(conn.assigns.flash, :success) =~
               "Welcome back!"

      assert Accounts.get_user!(user.id).confirmed_at == user.confirmed_at

      # log out, new conn - token should be invalid now
      conn = build_conn()

      # Try to use the same token again - should be redirected with error
      assert {:error, {:live_redirect, %{to: "/users/log-in"}}} =
               live(conn, ~p"/users/log-in/#{token}")
    end

    test "raises error for invalid token", %{conn: conn} do
      # Invalid token should redirect immediately
      assert {:error, {:live_redirect, %{to: "/users/log-in"}}} =
               live(conn, ~p"/users/log-in/invalid-token")
    end
  end
end
