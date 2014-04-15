class Timer
  constructor: (@app)->
    @going = false
    @count = 0
  
  tick: =>
    fraction = @count/10
    $('.timer').html fraction.toFixed(1)
    @count += 1
    window.setTimeout(@tick, 100) if @going
  
  end: =>
    @going = false
    @app.score = @count/10
    $(@app).trigger 'show', 'score'
  
  start: =>
    @count = 0
    @going = true
    @tick()

  stop: =>
    @going = false
    @count = 0

class Game 
  constructor: (@app)->
    $(@app).on('startGame', @startGame)
    @count = 8
    @timer = new Timer(@app)

  name: =>
    count = @count
    $(".table#{count}").prev('h3').text()

  startGame: (event, options = {count: @count, layout: @layout})=>
    $('.screen').hide()
    $('#container').show()
    @count = options.count if options.count
    @layout = options.layout if options.layout
    $(@app).trigger 'show', 'game'
    $('#container .dot').remove()
    @addDots()
    @makeDotsDraggable()
    @layoutDots()
    @timer.start()
  
  collide: (item1, item2)->
    xs = item1.left - item2.left
    xs = xs * xs
    ys = item1.top - item2.top
    ys = ys * ys
    range = $('#container .dot').width()
    dist = Math.sqrt xs + ys
    (dist < range)
  
  hitDetection: (event)=>
    dot = $ event.target
    dotid = dot.attr('data-id')
    dot_value = dot.attr('data-value')
    target = $("[data-value=#{dot_value}]").not("[data-id=#{dotid}]")
    if target[0] and @collide(dot.offset(), target.offset())
      $(@app).trigger 'collide'
      newValue = parseInt(dot_value) + 1
      target.attr('data-value', newValue).html(newValue)
      target.css background: 
        "hsl(#{newValue * 30},60%, 60%)"
      dot.remove()
      $('body').css 'background-color' : "hsl(#{newValue * 30},50%, 35%)"
      $(@app).trigger 'stat_hit'
      @timer.end() if dot_value is "#{@count}"
    else
      $(@app).trigger 'stat_miss'

  addDots: ->
    oldvalue = 1
    value = 1
    for i in [0..@count-1]
      $('#container').append "<div class='dot' data-value='#{value}' data-id='#{i}' >#{value}</div>"
      oldvalue = value
      value = oldvalue + 1
    $('#container').prepend '<div class="dot" data-value="1" data-id="1000" >1</div>'

  makeDotsDraggable: ->
    $('.dot').draggable
      stop: @hitDetection
      containment: "#container" 
      scroll: false
  
  getCoors: (e)->
    event = e.originalEvent
    coors = []
    if event.targetTouches and event.targetTouches.length
      thisTouch = event.targetTouches[0]
      coors[0] = thisTouch.clientX
      coors[1] = thisTouch.clientY
    else
      coors[0] = event.clientX
      coors[1] = event.clientY
    coors
  
  layoutDots : ->
    count = $('#container .dot').length
    layouts = []
    edge = Math.floor(Math.sqrt(count)) - 1
    x = 0
    y = 0
    for i in [0..(count - 1)]
      layouts.push { x:x, y:y }
      if x < edge 
        x += 1
      else
        x = 0
        y += 1
    layouts = layouts.sort -> 0.5 - Math.random()
    difference = ((edge + 1) /2 * 60)
    center = { x: ($('#container').width() /2) + difference, y: ($('#container').height() /2) + difference }
    $('#container .dot').each (index, dot)=>
      coords = layouts[index]
      $(dot).css
        left: center.x - coords.x * 70 
        top: center.y - coords.y * 70
        background: "hsl(#{index * 30},60%, 60%)"
      $(dot).css background: "hsl(30,60%, 60%)" if index is 0
      $('body').css 'background-color' : "hsl(#{index * 30},50%, 35%)"

class App
  constructor: ->
    @game = new Game @
    $(@).trigger 'startGame'
    $(@).on 'show', @show
    $('.startGame').click =>
      $(@).trigger 'startGame'


  show: (event, label)=>
    if label is 'score'
      $('.screen').hide()    
      $('#score').show()
      $('#scoreMessage').html("#{@score} seconds!")
$ ->
  window.app = new App()