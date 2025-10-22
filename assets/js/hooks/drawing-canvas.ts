import { Hook, makeHook } from 'phoenix_typed_hook'

class DrawingCanvasHook extends Hook {
  private canvas!: HTMLCanvasElement
  private ctx!: CanvasRenderingContext2D
  private isDrawing: boolean = false
  private lastX: number = 0
  private lastY: number = 0

  mounted() {
    this.canvas = this.el as HTMLCanvasElement
    this.ctx = this.canvas.getContext('2d')!

    this.canvas.width = this.canvas.offsetWidth
    this.canvas.height = this.canvas.offsetHeight

    // Set drawing style
    this.ctx.strokeStyle = 'black'
    this.ctx.lineWidth = 2
    this.ctx.lineCap = 'round'
    this.ctx.lineJoin = 'round'

    // Mouse down - start drawing
    this.canvas.addEventListener('mousedown', (event) => {
      this.isDrawing = true
      const { offsetX, offsetY } = event
      this.lastX = offsetX
      this.lastY = offsetY

      // Send mouse down event to the server
      this.pushEvent('mouse_down', { x: offsetX, y: offsetY })
    })

    // Mouse move - draw if mouse is down
    this.canvas.addEventListener('mousemove', (event) => {
      if (!this.isDrawing) return

      const { offsetX, offsetY } = event

      // Send mouse move event to the server
      this.pushEvent('mouse_move', { 
        x: offsetX, 
        y: offsetY,
        lastX: this.lastX,
        lastY: this.lastY
      })

      this.lastX = offsetX
      this.lastY = offsetY
    })

    // Mouse up - stop drawing
    this.canvas.addEventListener('mouseup', (event) => {
      if (!this.isDrawing) return
      
      this.isDrawing = false
      const { offsetX, offsetY } = event

      // Send mouse up event to the server
      this.pushEvent('mouse_up', { x: offsetX, y: offsetY })
    })

    // Mouse leave - stop drawing if mouse leaves canvas
    this.canvas.addEventListener('mouseleave', () => {
      if (this.isDrawing) {
        this.isDrawing = false
        this.pushEvent('mouse_up', { x: this.lastX, y: this.lastY })
      }
    })

    // Listen for draw events from the server
    this.handleEvent('draw_line', (data: { 
      x: number
      y: number
      lastX: number
      lastY: number
    }) => {
      this.drawLine(data.lastX, data.lastY, data.x, data.y)
    })

    this.handleEvent('draw_dot', (data: { x: number; y: number }) => {
      this.drawDot(data.x, data.y)
    })
  }

  drawLine(x1: number, y1: number, x2: number, y2: number) {
    this.ctx.beginPath()
    this.ctx.moveTo(x1, y1)
    this.ctx.lineTo(x2, y2)
    this.ctx.stroke()
  }

  drawDot(x: number, y: number) {
    this.ctx.fillStyle = 'black'
    this.ctx.beginPath()
    this.ctx.arc(x, y, 1, 0, Math.PI * 2)
    this.ctx.fill()
  }
}

export default makeHook(DrawingCanvasHook)
