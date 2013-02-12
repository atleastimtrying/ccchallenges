class Animation
  constructor: ->
    @setupVars()
    @setupBindings()

  setupVars: ->
    @canvas = document.getElementsByTagName('canvas')[0]
    @ctx = @canvas.getContext '2d'
    @x = 0
    @y = 0
    @r = 45
    @width = 700
    @height = 250
    @clear()

  setupBindings: ->
    @canvas.addEventListener 'mousemove', @mousemove, false

  mousemove: (event)=>
    x = event.offsetX
    y = event.offsetY
    @draw x, y
  
  draw: (x,y)->
    @background()
    @r %= 360
    @r += 10
    @ctx.strokeStyle = @calcStyle x, y, @r
    @place x, y, @r, @foursquares

  foursquares: =>
    @ctx.strokeRect -25, -5, 10, 10
    @ctx.strokeRect 15, -5, 10, 10
    @ctx.strokeRect -5, 15, 10, 10
    @ctx.strokeRect -5, -25, 10, 10 
    
  place: (x,y,r, fn)->
    @ctx.translate x, y
    @ctx.rotate @rad(r)
    fn()
    @ctx.rotate @rad(-r)
    @ctx.translate -x, -y


  calcStyle: (x, y, r)=>
    r = Math.round (x / @width) * 255
    g = Math.round (y / @height) * 255
    b = Math.round (r / 360) * 255
    "rgb(#{r},#{g},#{b})"

  background : ->
    @ctx.fillStyle = 'rgba(255,255,255,0.2)'
    @ctx.fillRect 0, 0, @width, @height

  rad:(degrees)->
    degrees * Math.PI / 180

  clear: ->
    @canvas.width = @width
    @canvas.height = @height


window.onload = ->
  window.animation = new Animation()