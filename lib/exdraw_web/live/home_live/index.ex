defmodule ExdrawWeb.HomeLive.Index do
  use ExdrawWeb, :live_view

  @topic "drawing:home"

  @impl true
  def render(assigns) do
    ~H"""
    <main class="flex h-dvh flex-col size-full">
      <Layouts.flash_group flash={@flash} />
      <Layouts.header current_scope={@current_scope} />
      <div class="size-full p-10">
        <canvas
          id="drawing-canvas"
          phx-hook="DrawingCanvasHook"
          phx-update="ignore"
          class="border size-full rounded-lg"
        />
      </div>
    </main>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    # Subscribe to the drawing topic so this user receives broadcasts
    Phoenix.PubSub.subscribe(Exdraw.PubSub, @topic)

    {:ok, socket}
  end

  @impl true
  def handle_event("mouse_down", %{"x" => x, "y" => y}, socket) do
    # Broadcast the mouse down event to all subscribers
    Phoenix.PubSub.broadcast(
      Exdraw.PubSub,
      @topic,
      {:mouse_down, %{"x" => x, "y" => y}}
    )

    {:noreply, socket}
  end

  @impl true
  def handle_event(
        "mouse_move",
        %{"x" => x, "y" => y, "lastX" => last_x, "lastY" => last_y},
        socket
      ) do
    # Broadcast the mouse move event to all subscribers
    Phoenix.PubSub.broadcast(
      Exdraw.PubSub,
      @topic,
      {:mouse_move, %{"x" => x, "y" => y, "lastX" => last_x, "lastY" => last_y}}
    )

    {:noreply, socket}
  end

  @impl true
  def handle_event("mouse_up", %{"x" => x, "y" => y}, socket) do
    # Broadcast the mouse up event to all subscribers
    Phoenix.PubSub.broadcast(
      Exdraw.PubSub,
      @topic,
      {:mouse_up, %{"x" => x, "y" => y}}
    )

    {:noreply, socket}
  end

  @impl true
  def handle_info({:mouse_down, %{"x" => x, "y" => y}}, socket) do
    # Draw a dot at the starting position
    {:noreply, push_event(socket, "draw_dot", %{"x" => x, "y" => y})}
  end

  @impl true
  def handle_info(
        {:mouse_move, %{"x" => x, "y" => y, "lastX" => last_x, "lastY" => last_y}},
        socket
      ) do
    # Draw a line from the last position to the current position
    {:noreply,
     push_event(socket, "draw_line", %{"x" => x, "y" => y, "lastX" => last_x, "lastY" => last_y})}
  end

  @impl true
  def handle_info({:mouse_up, _params}, socket) do
    # Currently, we don't need to do anything on mouse up
    # But we keep this handler in case we want to add functionality later
    {:noreply, socket}
  end
end
