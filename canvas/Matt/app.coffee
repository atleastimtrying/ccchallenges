SPEED = 10
WIDTH = 350
RANDOMNESS = 120
MIDDLE = WIDTH / 2
MOVE_MULTIPLIER = 50

class Globule
  constructor: (@x, @y) ->
    @base = @y
    @img = new Image()
    @img.src = 'lava.png'

  excite: ->
    @exciteByHeat()
    @exciteByProximity()

  exciteByHeat: ->
    @y = @y - (Math.random() * @heatMultiplier()) + @randomizer()

  heatMultiplier: ->
    dist = Math.abs(@base - @y)
    return 0.5 if dist < @base/4
    return 0.2 if dist < 2 * @base/4
    return 0.1 if dist < 3 * @base/4
    return -0.2 if dist < 4 * @base/4
    -0.5

  randomizer: ->
    (Math.random() - 0.5) * RANDOMNESS

  exciteByProximity: ->
    @x = @x + (Math.random() * @proximityMultiplier() * SPEED)


  # Todo: Weighted on mass, not location
  proximityMultiplier: ->
    dist = Math.abs(@x)
    return 0.5 if dist < MIDDLE - (WIDTH / 2)
    return 0.2 if dist < MIDDLE
    return -0.2 if dist < MIDDLE + (WIDTH / 2)
    return -0.5 if dist < WIDTH
    -0.5

  paint: (ctx) ->
    ctx.drawImage(@img, @x - 5, @y - 5)
    @excite()


class LavaLamp
  constructor: ->
    @initSurface()
    @initPhysics()
    @run()

  initSurface: ->
    @elem = document.getElementsByTagName('canvas')[0]
    @ctx = @elem.getContext('2d')

  initPhysics: ->
    @globules = @initializeGlobules()

  initializeGlobules: ->
    new Globule(n, @elem.height - 5) for n in [0..300]

  run: =>
    @drawBg()
    g.paint @ctx for g in @globules
    setTimeout(@run, 100)

  drawBg: ->
    @ctx.fillStyle = '#000'
    @ctx.fillRect(0, 0, 300, 200)


window.document.body.onload = -> new LavaLamp()
window.document.onkeypress = (event)=>
  MIDDLE -= MOVE_MULTIPLIER if event.charCode is 104
  MIDDLE += MOVE_MULTIPLIER if event.charCode is 108
