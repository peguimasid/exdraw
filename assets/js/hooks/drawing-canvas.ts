import { Hook, makeHook } from 'phoenix_typed_hook'

class DrawingCanvasHook extends Hook {
  mounted() {
    const canvas = this.el as HTMLCanvasElement
    console.log(canvas)
    const ctx = canvas.getContext('2d')!

    canvas.width = canvas.offsetWidth
    canvas.height = canvas.offsetHeight

    canvas.addEventListener('click', (event) => {
      const offsetX = event.offsetX
      const offsetY = event.offsetY

      ctx.fillStyle = 'black'
      ctx.beginPath()
      ctx.arc(offsetX, offsetY, 5, 0, Math.PI * 2)
      ctx.fill()

      this.pushEvent('canvas_click', { x: offsetX, y: offsetY })
    })
  }
}

export default makeHook(DrawingCanvasHook)
