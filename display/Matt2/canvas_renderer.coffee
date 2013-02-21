# Stolen wholesale from coffee_physics, with some tweaks https://github.com/soulwire/Coffee-Physics


### Base Renderer ###
class Renderer

    constructor: ->

        @width = 0
        @height = 0

        @renderParticles = true
        @renderSprings = true
        @renderMouse = false
        @initialized = false
        @renderTime = 0

    init: (physics) ->

        @initialized = true

    render: (physics) ->

        if not @initialized then @init physics

    setSize: (@width, @height) =>

    destroy: ->


### Canvas Renderer ###
class window.CanvasRenderer extends Renderer

    constructor: (@canvas = document.createElement 'canvas')->

        super
        @ctx = @canvas.getContext '2d'

        # Set the DOM element.
        @domElement = @canvas

    init: (physics) ->

        super physics

    render: (physics) ->

        super physics

        time = new Date().getTime()

        # Draw velocity.
        vel = new Vector()

        # Draw heading.
        dir = new Vector()

        # Clear canvas.
        @canvas.width = @canvas.width

        @ctx.globalCompositeOperation = 'lighter'
        @ctx.lineWidth = 1

        # Draw particles.
        if @renderParticles

            TWO_PI = Math.PI * 2

            for p in physics.particles.reverse()

                @ctx.beginPath()
                @ctx.arc(p.pos.x, p.pos.y, p.radius, 0, TWO_PI, no)

                @ctx.fillStyle = (p.colour or 'rgba(255,255,255,0.5)')
                @ctx.fill()

                if p.name?
                  @ctx.font = '15px sans-serif'
                  @ctx.textAlign = 'left'
                  @ctx.fillStyle = 'blue'
                  @ctx.fillText(p.name, p.pos.x + p.radius + 5, p.pos.y + 5)

        if @renderSprings

            @ctx.strokeStyle = 'rgba(255,255,255,0.1)'
            @ctx.beginPath()

            for s in physics.springs
                @ctx.moveTo(s.p1.pos.x, s.p1.pos.y)
                @ctx.lineTo(s.p2.pos.x, s.p2.pos.y)

            @ctx.stroke()

        if @renderMouse

            # Draw mouse.
            @ctx.fillStyle = 'rgba(255,255,255,0.1)'
            @ctx.beginPath()
            @ctx.arc(@mouse.pos.x, @mouse.pos.y, 20, 0, TWO_PI)
            @ctx.fill()

        @renderTime = new Date().getTime() - time

    setSize: (@width, @height) =>

        super @width, @height

        @canvas.width = @width
        @canvas.height = @height