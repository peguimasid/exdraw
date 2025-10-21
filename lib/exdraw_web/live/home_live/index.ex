defmodule ExdrawWeb.HomeLive.Index do
  use ExdrawWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <div class="h-dvh w-full flex flex-col">
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
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
