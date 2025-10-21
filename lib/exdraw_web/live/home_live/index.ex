defmodule ExdrawWeb.HomeLive.Index do
  use ExdrawWeb, :live_view

  @topic "drawing:home"

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.flash_group flash={@flash} />
    <Layouts.header current_scope={@current_scope} />
    <div class="flex-1 w-full p-10 overflow-hidden">
      <canvas
        id="drawing-canvas"
        phx-hook="DrawingCanvasHook"
        phx-update="ignore"
        class="border w-full h-full block"
      />
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    # Subscribe to the drawing topic so this user receives broadcasts
    Phoenix.PubSub.subscribe(Exdraw.PubSub, @topic)

    {:ok, socket}
  end

  @impl true
  def handle_event("canvas_click", %{"x" => x, "y" => y}, socket) do
    # Broadcast the click event to all subscribers (including this user)
    Phoenix.PubSub.broadcast(
      Exdraw.PubSub,
      @topic,
      {:canvas_click, %{"x" => x, "y" => y}}
    )

    {:noreply, socket}
  end

  @impl true
  def handle_info({:canvas_click, %{"x" => x, "y" => y}}, socket) do
    # Send a message to the client to draw the dot via the hook
    {:noreply, push_event(socket, "draw_dot", %{"x" => x, "y" => y})}
  end
end
