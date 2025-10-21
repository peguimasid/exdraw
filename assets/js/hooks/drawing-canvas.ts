import { Hook, makeHook } from 'phoenix_typed_hook'

class DrawingCanvasHook extends Hook {
  private canvas!: HTMLCanvasElement
  private ctx!: CanvasRenderingContext2D

  mounted() {
    this.canvas = this.el as HTMLCanvasElement
    this.ctx = this.canvas.getContext('2d')!

    this.canvas.width = this.canvas.offsetWidth
    this.canvas.height = this.canvas.offsetHeight

    // Listen for canvas clicks
    this.canvas.addEventListener('click', (event) => {
      const offsetX = event.offsetX
      const offsetY = event.offsetY

      // Send click event to the server (will be broadcasted to all users)
      this.pushEvent('canvas_click', { x: offsetX, y: offsetY })
    })

    this.handleEvent('draw_dot', (data: { x: number; y: number }) => {
      this.drawDot(data.x, data.y)
    })
  }

  drawDot(x: number, y: number) {
    this.ctx.fillStyle = 'black'
    this.ctx.beginPath()
    this.ctx.arc(x, y, 5, 0, Math.PI * 2)
    this.ctx.fill()
  }
}

export default makeHook(DrawingCanvasHook)
