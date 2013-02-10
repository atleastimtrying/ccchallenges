stdin = process.openStdin()
stdin.setEncoding 'utf8'

player =
  x:0
  y:0
  string: -> player.x + '' + player.y

places = 
  '00': 'The very centre of the universe'
  '01': 'The enchanted forest'
  '02': 'The crystal lake'
  '10': 'The mushroom kingdom'
  '11': 'The rotting garbage heap'
  '12': 'The infinite ocean'
  '20': 'The barren desert'
  '21': 'The icy wilderness'
  '22': 'The teeming forest'

describe = ->
  place = places[player.string()]
  if place
    console.log place
  else
    console.log 'nothing, nothing at all! better go back!'
commands =
  north: ->
    console.log 'you travel north'
    player.y -= 1
    describe()
  
  south: ->
    console.log 'you travel south'
    player.y += 1
    describe()
  east: ->
    console.log 'you travel east'
    player.x += 1
    describe()
  west: ->
    console.log 'you travel west'
    player.x -= 1
    describe()
  look: ->
    console.log 'you look around you, you can see:'
    describe()

  quit: ->
    process.exit()

tryCommand = (command)-> 
  action = commands[command.trim()]
  if action
    action()
  else
    console.log "Not sure how to #{command.trim()}"

console.log 'Welcome to the text adventure, your available commands are north, south, east, west, look and quit'
stdin.on 'data', tryCommand