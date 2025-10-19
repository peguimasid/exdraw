defmodule ExdrawWeb.HomeLive.Index do
  use ExdrawWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <div class="h-dvh w-full flex flex-col">
      <Layouts.flash_group flash={@flash} />
      <Layouts.header current_scope={@current_scope} />
      <div>This is the page to have the board</div>
      <button phx-click="add" class="btn btn-primary size-fit">{@count}</button>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, count: 0)}
  end

  @impl true
  def handle_event("add", _params, socket) do
    {:noreply, assign(socket, count: socket.assigns.count + 1)}
  end
end
