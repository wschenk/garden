console.log "Hi there"

canvas = $("#drawarea")

class World
  constructor: (@canvas, @config) ->
    @map = []
    @renderer = new ObeliskRenderer( @, @canvas )
    new ControlGui( @, @config)

  populate: ->
    for x in [0..@config.width]
      for y in [0..@config.height]
        setTile x, y, new Ground(x,y)

  setTile: (x,y,ground) ->
    @map[x*@config.width + y] = ground

  getTile: (x,y) ->
    @map[x*@config.width + y]

  redraw: ->
    @renderer.redraw()

class ObeliskRenderer
  constructor: (@world, @canvas) ->
    @control = @world.config
    @setupDragging()
    @setupZooming()

    point = new obelisk.Point 270, 120
    @pixelView = new obelisk.PixelView canvas, point

    # dimension = new obelisk.CubeDimension 20, 20, 60

    # color = new obelisk.CubeColor().getByHorizontalColor(obelisk.ColorPattern.GRAY)

    # cube = new obelisk.Cube dimension, color

  setupDragging: ->
    dragging = false
    start_x = 0
    start_y = 0
    @canvas.mousedown (e) ->
      dragging = true
      start_x = e.pageX
      start_y = e.pageY

    @canvas.mouseup ->
      dragging = false

    @canvas.mousemove (e) =>
      if dragging
        dx = e.pageX - start_x
        dy = e.pageY - start_y
        start_x = e.pageX
        start_y = e.pageY
        @control.offset_x += dx
        @control.offset_y += dy
        @world.redraw()

  setupZooming: ->
    @canvas.on 'mousewheel', (event, delta) =>
      new_size = @control.size
      if delta > 0
        new_size += 2 
        if new_size > 40
          new_size = 40
        else
          @control.offset_y -= 2
          @control.offset_x -= 2
      if delta < 0
        new_size -= 2 
        if new_size < 5
          new_size = 6
        else
          @control.offset_y += 2
          @control.offset_x += 2

      @control.size = new_size

      @world.redraw()
      event.preventDefault()
      false

  redraw: ->
    @pixelView.clear()

    size = new obelisk.BrickDimension @control.size, @control.size
    color = new obelisk.SideColor().getByInnerColor(obelisk.ColorPattern.GRASS_GREEN)

    x_dif = 0
    y_dif = 0
    x_dif += @control.offset_x
    y_dif -= @control.offset_x

    x_dif += @control.offset_y
    y_dif += @control.offset_y

    for x in [1..@control.width]
      for y in [1..@control.height]
        brick = new obelisk.Brick( size, color, @control.border )

        p3d = new obelisk.Point3D(x * @control.size + x_dif, y * @control.size + y_dif, 0)

        @pixelView.renderObject brick, p3d


class ControlGui
  constructor: (@world, @control) ->
    gui = new dat.GUI()
    gui.add( control, 'width', 5, 20).step(1).onChange =>
      @world.redraw()
    gui.add( control, 'height', 5, 20).step(1).onChange =>
      @world.redraw()
    gui.add( control, 'size', 5, 40).step(2).listen().onChange =>
      @world.redraw()
    gui.add( control, 'offset_x', -100, 100).listen().onChange =>
      @world.redraw()
    gui.add( control, 'offset_y', -100, 100).listen().onChange =>
      @world.redraw()
    gui.add( control, 'running' )
    gui.add( control, 'border' ).onChange =>
      @world.redraw()


class Ground
  constructor:(@x,@y)->
  draw = ->



if canvas
  control = {
    width: 10
    height: 10
    size: 30
    offset_x: 0
    offset_y: 0
    running: false
    border: false
  }

  world = new World( canvas, control )
  world.redraw()
