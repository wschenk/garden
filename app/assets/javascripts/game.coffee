console.log "Hi there"

canvas = $("#drawarea")

if canvas
  point = new obelisk.Point 270, 120
  pixelView = new obelisk.PixelView canvas, point

  dimension = new obelisk.CubeDimension 20, 20, 60

  color = new obelisk.CubeColor().getByHorizontalColor(obelisk.ColorPattern.GRAY)

  cube = new obelisk.Cube dimension, color

  control = {
    cubes: 1
  }

  redraw = ->
    pixelView.clear()

    for x in [1..control.cubes]
      p3d = new obelisk.Point3D(0, x * 40, 0)

      pixelView.renderObject cube, p3d

  gui = new dat.GUI()
  cubes = gui.add( control, 'cubes', 1, 10 ).step(1)
  cubes.onChange ->
    redraw()

  redraw()
