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
              <svg
                class="size-4 text-base-content"
                viewBox="0 0 438.549 438.549"
              >
                <path
                  fill="currentColor"
                  d="M409.132 114.573c-19.608-33.596-46.205-60.194-79.798-79.8-33.598-19.607-70.277-29.408-110.063-29.408-39.781 0-76.472 9.804-110.063 29.408-33.596 19.605-60.192 46.204-79.8 79.8C9.803 148.168 0 184.854 0 224.63c0 47.78 13.94 90.745 41.827 128.906 27.884 38.164 63.906 64.572 108.063 79.227 5.14.954 8.945.283 11.419-1.996 2.475-2.282 3.711-5.14 3.711-8.562 0-.571-.049-5.708-.144-15.417a2549.81 2549.81 0 01-.144-25.406l-6.567 1.136c-4.187.767-9.469 1.092-15.846 1-6.374-.089-12.991-.757-19.842-1.999-6.854-1.231-13.229-4.086-19.13-8.559-5.898-4.473-10.085-10.328-12.56-17.556l-2.855-6.57c-1.903-4.374-4.899-9.233-8.992-14.559-4.093-5.331-8.232-8.945-12.419-10.848l-1.999-1.431c-1.332-.951-2.568-2.098-3.711-3.429-1.142-1.331-1.997-2.663-2.568-3.997-.572-1.335-.098-2.43 1.427-3.289 1.525-.859 4.281-1.276 8.28-1.276l5.708.853c3.807.763 8.516 3.042 14.133 6.851 5.614 3.806 10.229 8.754 13.846 14.842 4.38 7.806 9.657 13.754 15.846 17.847 6.184 4.093 12.419 6.136 18.699 6.136 6.28 0 11.704-.476 16.274-1.423 4.565-.952 8.848-2.383 12.847-4.285 1.713-12.758 6.377-22.559 13.988-29.41-10.848-1.14-20.601-2.857-29.264-5.14-8.658-2.286-17.605-5.996-26.835-11.14-9.235-5.137-16.896-11.516-22.985-19.126-6.09-7.614-11.088-17.61-14.987-29.979-3.901-12.374-5.852-26.648-5.852-42.826 0-23.035 7.52-42.637 22.557-58.817-7.044-17.318-6.379-36.732 1.997-58.24 5.52-1.715 13.706-.428 24.554 3.853 10.85 4.283 18.794 7.952 23.84 10.994 5.046 3.041 9.089 5.618 12.135 7.708 17.705-4.947 35.976-7.421 54.818-7.421s37.117 2.474 54.823 7.421l10.849-6.849c7.419-4.57 16.18-8.758 26.262-12.565 10.088-3.805 17.802-4.853 23.134-3.138 8.562 21.509 9.325 40.922 2.279 58.24 15.036 16.18 22.559 35.787 22.559 58.817 0 16.178-1.958 30.497-5.853 42.966-3.9 12.471-8.941 22.457-15.125 29.979-6.191 7.521-13.901 13.85-23.131 18.986-9.232 5.14-18.182 8.85-26.84 11.136-8.662 2.286-18.415 4.004-29.263 5.146 9.894 8.562 14.842 22.077 14.842 40.539v60.237c0 3.422 1.19 6.279 3.572 8.562 2.379 2.279 6.136 2.95 11.276 1.995 44.163-14.653 80.185-41.062 108.068-79.226 27.88-38.161 41.825-81.126 41.825-128.906-.01-39.771-9.818-76.454-29.414-110.049z"
                />
              </svg>
              <span>GitHub</span>
            </.link>
            <.link
              href={~p"/auth/google"}
              class="btn btn-outline flex items-center justify-center gap-2"
            >
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
            </.link>
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
