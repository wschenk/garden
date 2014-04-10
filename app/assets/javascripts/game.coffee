console.log "Hi there"

canvas = $("#drawarea")

class World
  constructor: (@config) ->
    @map = []

  populate: ->
    for x in [0..@config.width]
      for y in [0..@config.height]
        setTile x, y, new Ground()

  setTile: (x,y,ground) ->
    @map[x*@config.width + y] = ground

class Ground
  draw = ->


if canvas
  point = new obelisk.Point 270, 120
  pixelView = new obelisk.PixelView canvas, point

  dimension = new obelisk.CubeDimension 20, 20, 60

  color = new obelisk.CubeColor().getByHorizontalColor(obelisk.ColorPattern.GRAY)

  cube = new obelisk.Cube dimension, color

  control = {
    width: 10
    height: 10
    size: 10
    running: false
    border: false
  }

  gui = new dat.GUI()
  gui.add( control, 'width', 5, 20).step(1).onChange ->
    redraw()
  gui.add( control, 'height', 5, 20).step(1).onChange ->
    redraw()
  gui.add( control, 'size', 5, 40).step(2).onChange ->
    redraw()
  gui.add( control, 'running' )
  gui.add( control, 'border' ).onChange ->
    redraw()

  redraw = ->
    pixelView.clear()

    console.log "Redraw"

    size = new obelisk.BrickDimension control.size, control.size
    color = new obelisk.SideColor().getByInnerColor(obelisk.ColorPattern.GRASS_GREEN)

    for x in [1..control.width]
      for y in [1..control.height]
        brick = new obelisk.Brick( size, color, control.border )

        p3d = new obelisk.Point3D(x * control.size, y * control.size, 0)

        pixelView.renderObject brick, p3d

  world = new World( control )

  init = ->
    # world.populate()
    redraw()

  redraw()
  