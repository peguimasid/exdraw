defmodule ExdrawWeb.UserLive.Login do
  alias Exdraw.Accounts
  use ExdrawWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.flash_group flash={@flash} />
    <div class="flex h-dvh bg-base-200 items-center justify-center">
      <div class="w-full max-w-md">
        <div class="flex items-center justify-center gap-3 mb-8">
          <div class="size-9 bg-primary rounded-lg flex items-center justify-center">
            <.icon name="hero-pencil-square" class="size-5 text-primary-content" />
          </div>
          <h1 class="text-2xl font-semibold text-base-content">exdraw</h1>
        </div>

        <div class="rounded-2xl shadow-lg bg-base-100 p-8">
          <div class="mb-6">
            <.link
              navigate={~p"/"}
              class="inline-flex items-center gap-2 text-sm text-base-content/60 hover:text-base-content transition-colors"
            >
              <.icon name="hero-arrow-left" class="size-4" /> Back to home
            </.link>
          </div>
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
            <.link
              href={~p"/auth/github"}
              class="btn btn-outline flex items-center justify-center gap-2"
            >
              <svg class="size-4" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
                <path d="M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z" />
              </svg>
              <span>GitHub</span>
            </.link>
            <button class="btn btn-outline flex items-center justify-center gap-2">
              <svg
                class="size-4"
                viewBox="0 0 754 768"
                fill="none"
                xmlns="http://www.w3.org/2000/svg"
              >
                <path
                  d="M753.32 392.727C753.32 365.498 750.876 339.316 746.338 314.182H384.68V462.895H591.342C582.265 510.72 555.036 551.215 514.193 578.444V675.142H638.818C711.429 608.116 753.32 509.673 753.32 392.727Z"
                  fill="#4285F4"
                />
                <path
                  d="M384.68 768C488.36 768 575.284 733.789 638.818 675.142L514.193 578.444C479.982 601.484 436.346 615.447 384.68 615.447C284.84 615.447 200.011 548.073 169.64 457.309H41.8728V556.451C105.058 681.775 234.571 768 384.68 768Z"
                  fill="#34A853"
                />
                <path
                  d="M169.64 456.96C161.96 433.92 157.422 409.484 157.422 384C157.422 358.516 161.96 334.08 169.64 311.04V211.898H41.8728C15.691 263.564 0.680054 321.862 0.680054 384C0.680054 446.138 15.691 504.436 41.8728 556.102L141.364 478.604L169.64 456.96Z"
                  fill="#FBBC05"
                />
                <path
                  d="M384.68 152.902C441.233 152.902 491.502 172.451 531.647 210.153L641.611 100.189C574.935 38.0509 488.36 0 384.68 0C234.571 0 105.058 86.2255 41.8728 211.898L169.64 311.04C200.011 220.276 284.84 152.902 384.68 152.902Z"
                  fill="#EA4335"
                />
              </svg>

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
