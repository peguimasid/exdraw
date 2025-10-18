defmodule ExdrawWeb.UserLive.Login do
  alias Exdraw.Accounts
  use ExdrawWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div class="flex items-center justify-center">
        <div class="w-full max-w-md">
          <%!-- Logo --%>
          <div class="flex items-center justify-center gap-3 mb-8">
            <div class="size-9 bg-primary rounded-lg flex items-center justify-center">
              <.icon name="hero-pencil-square" class="size-5 text-primary-content" />
            </div>
            <h1 class="text-2xl font-semibold text-base-content">exdraw</h1>
          </div>

          <%!-- Card --%>
          <div class="rounded-2xl border p-8">
            <div class="mb-6">
              <h2 class="text-2xl font-semibold text-base-content mb-2">Welcome back</h2>
              <p class="text-sm text-base-content/60">
                <%= if @show_password do %>
                  Sign in with your email and password
                <% else %>
                  Sign in with your email address
                <% end %>
              </p>
            </div>

            <div :if={local_mail_adapter?()} class="alert alert-info mb-6 text-sm">
              <.icon name="hero-information-circle" class="size-5 shrink-0" />
              <div>
                <p>
                  Local mail adapter active. <.link href="/dev/mailbox" class="underline">View mailbox</.link>.
                </p>
              </div>
            </div>

            <%= if @show_password do %>
              <.form
                :let={f}
                for={@form}
                id="login_form_password"
                action={~p"/users/log-in"}
                phx-submit="submit_password"
                phx-trigger-action={@trigger_submit}
                class="space-y-4"
              >
                <div>
                  <label class="block text-sm font-medium text-base-content mb-2">
                    Email address
                  </label>
                  <.input
                    field={f[:email]}
                    type="email"
                    placeholder="you@example.com"
                    autocomplete="username"
                    required
                    class="input input-bordered w-full"
                  />
                </div>

                <div>
                  <label class="block text-sm font-medium text-base-content mb-2">Password</label>
                  <.input
                    field={f[:password]}
                    type="password"
                    placeholder="Enter your password"
                    autocomplete="current-password"
                    required
                    class="input input-bordered w-full"
                    phx-mounted={JS.focus()}
                  />
                </div>

                <.button
                  class="btn btn-primary w-full"
                  name={f[:remember_me].name}
                  value="true"
                >
                  Sign in
                </.button>

                <button
                  type="button"
                  phx-click="toggle_mode"
                  class="w-full text-center text-sm text-base-content/60 hover:text-base-content"
                >
                  Use magic link instead
                </button>
              </.form>
            <% else %>
              <.form
                :let={f}
                for={@form}
                id="login_form_magic"
                action={~p"/users/log-in"}
                phx-submit="submit_magic"
                class="space-y-4"
              >
                <div>
                  <label class="block text-sm font-medium text-base-content mb-2">
                    Email address
                  </label>
                  <.input
                    field={f[:email]}
                    type="email"
                    placeholder="you@example.com"
                    autocomplete="username"
                    required
                    class="input input-bordered w-full"
                    phx-mounted={JS.focus()}
                  />
                </div>

                <.button class="btn btn-primary shadow-none w-full">
                  Continue with email <span class="ml-2">→</span>
                </.button>

                <button
                  type="button"
                  phx-click="toggle_mode"
                  class="w-full text-center text-sm text-base-content/60 hover:text-base-content"
                >
                  Sign in with password instead
                </button>
              </.form>
            <% end %>

            <div class="flex items-center gap-4 my-6">
              <div class="flex-1 h-px bg-base-300"></div>
              <span class="text-xs text-base-content/40 uppercase">or continue with</span>
              <div class="flex-1 h-px bg-base-300"></div>
            </div>

            <div class="grid grid-cols-2 gap-3">
              <button class="btn btn-outline flex items-center justify-center gap-2">
                <.icon name="hero-code-bracket" class="size-5" />
                <span>GitHub</span>
              </button>
              <button class="btn btn-outline flex items-center justify-center gap-2">
                <span class="text-lg">G</span>
                <span>Google</span>
              </button>
            </div>

            <%!-- Sign up link (hide during re-authentication) --%>
            <div
              :if={is_nil(@current_scope) || is_nil(@current_scope.user)}
              class="mt-6 text-center text-sm text-base-content/60"
            >
              Don't have an account?
              <.link navigate={~p"/users/register"} class="text-primary hover:underline font-medium">
                Sign up
              </.link>
            </div>
          </div>

          <%!-- Footer --%>
          <div class="mt-6 text-center text-xs text-base-content/40">
            By continuing, you agree to our <a href="#" class="hover:underline">Terms of Service</a>
            and <a href="#" class="hover:underline">Privacy Policy</a>
          </div>
        </div>
      </div>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    email =
      Phoenix.Flash.get(socket.assigns.flash, :email) ||
        get_in(socket.assigns, [:current_scope, Access.key(:user), Access.key(:email)])

    form = to_form(%{"email" => email}, as: "user")

    {:ok, assign(socket, form: form, trigger_submit: false, show_password: false)}
  end

  @impl true
  def handle_event("submit_password", _params, socket) do
    {:noreply, assign(socket, :trigger_submit, true)}
  end

  def handle_event("toggle_mode", _params, socket) do
    {:noreply, assign(socket, :show_password, !socket.assigns.show_password)}
  end

  def handle_event("submit_magic", %{"user" => %{"email" => email}}, socket) do
    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_login_instructions(
        user,
        &url(~p"/users/log-in/#{&1}")
      )
    end

    message =
      "If your email is in our system, you will receive instructions for logging in shortly."

    {:noreply,
     socket
     |> put_flash(:success, message)
     |> push_navigate(to: ~p"/users/log-in")}
  end

  defp local_mail_adapter? do
    Application.get_env(:exdraw, Exdraw.Mailer)[:adapter] == Swoosh.Adapters.Local
  end
end
