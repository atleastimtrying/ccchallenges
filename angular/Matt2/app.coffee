class NamedParticle extends Particle
  constructor: (@name, mass) ->
    super mass


class Hugo
  constructor: (@json) ->
    @canvas = document.getElementById('display')
    @setupGraphics()
    @buildElements()
    @repulsify()
    @animate()

  setupGraphics: ->
    @size = [@width, @height] = [730, 500]
    @size_with_border = [@width - 20, @height - 20]

  buildElements: ->
    @physics = new Physics()
    @collision = new Collision()
    @edgebounce = new EdgeBounce new Vector(0,0), new Vector(@size_with_border...)
    @centerAttraction = new Attraction new Vector(@width / 2, @height / 2)
    @buildAssociativeOrArray(@json, @buildString("START"))

  repulsify: ->
    for particle in @physics.particles
      for other_particle in @physics.particles
        repulse = new Attraction particle.pos, 150, -1000
        other_particle.behaviours.push repulse

  buildAssociativeOrArray: (obj, parent)->
    return @buildArray obj, parent if @_isArray(obj)
    return @buildString obj, parent if @_isString(obj)
    @buildAssociative obj, parent

  buildAssociative: (hsh, parent)->
    for k of hsh
      key_particle = @addParticle k
      @linkParticles parent, key_particle
      val_particle = @buildAssociativeOrArray hsh[k], key_particle

      @linkParticles key_particle, val_particle
    parent

  buildString: (str, parent)-> @addParticle str

  buildArray: (arr, parent)->
    for item in arr
      @linkParticles parent, @buildAssociativeOrArray(item)
    parent

  addParticle: (name)->
    p = new NamedParticle name
    p.setRadius 10
    p.setMass 10
    p.pos = new Vector Random(0,@width), Random(0, @height)
    p.vel = new Vector Random(-100,100), Random(-100,100)
    @physics.particles.push p
    @makeCollidable p
    p

  makeCollidable: (p)->
    p.behaviours.push(@collision, @edgebounce, @centerAttraction);
    @collision.pool.push p

  linkParticles: (p1, p2)->
    @physics.springs.push new Spring(p1, p2, 30)

  animate: =>
    @physics.step()
    unless @renderer
      @renderer = new CanvasRenderer(@canvas)
      @renderer.setSize @size...

    @renderer.render @physics
    requestAnimationFrame @animate

  _isArray: (obj)-> Object.prototype.toString.call( obj ) is '[object Array]'
  _isString: (obj)-> (typeof obj) is 'string'



launcher = ->
  new Hugo(window.my_json);


document.body.onload = launcher