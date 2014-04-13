stdin = process.openStdin()
stdin.setEncoding 'utf8'

Date.prototype.toHumanDateString = ->
  this.getUTCFullYear() + '/' + (this.getUTCMonth() + 1) + '/' + this.getUTCDate()

class World
  constructor: ->
    @map =
      # Note: Clockwise from south
      none:      ['THE VOID',           "Uh, captain, um, there's nothing here. Actual nothingness. Best go back."]
      'x0_y0':   ['Home',               "You are safely home, away from toil and strife. Best stay here, nobody likes a hero."]
      'x0_y1':   ['Ipswich',            "They say that those who enter Ipswich leave crazy. I've been there, and I'm as sane a peacock as when I entered. Baaaaaa."]
      'x1_y1':   ['Valley of despair',  "I got a bad feeling about this, boss"]
      'x1_y0':   ['Yellow brick road',  "You see a brick road, with a small house beside it and a green ooze eminating from the foundations. Small munchkins chant your name."]
      'x1_y-1':  ['Rode Too Parahdyes', "I once heard a story about muggers promising people heaven along a certain road, then killing them and taking their money. I'm sure that's not the case here though."]
      'x0_y-1':  ['The Mummy',          "Your mother meets you on the road - you forgot your packed lunch. One big sloppy kiss later, gain +1 nourishment points, and -192 peer esteem points."]
      'x0_y-2':  ['Norwich',            "A canary sits beside a lake in which a girl seems to be swimming lengths at great speed. A nice chap stops by and tells you that a human heart can squirt blood 30ft. Maybe it isn't safe here after all."]
      'x-1_y-1': ['Graveyard',          "You see a tombstone: [YOUR NAME] - Died #{new Date().toHumanDateString()}. Stuck his nose in graveyards that it didn't belong... in? His nose. It just... he just shouldn't have stuck it there."]
      'x-1_y0':  ['Misty mountains',    "Yeesh, so much mist. You could lose a whole town in this. Best keep moving"]
      'x-1_y1':  ['Road to wales',      "What's that smell? Mint sauce?"]

  getLocation: (x, y)->
    location = @locationToString x,y
    return @map['none'] unless @map[location]?
    @map[location]

  locationToString: (x,y) -> "x#{x}_y#{y}"

  surroundings: (x,y) ->
    east: @getLocation(x+1,y)
    west: @getLocation(x-1,y)
    south: @getLocation(x,y+1)
    north: @getLocation(x,y-1)


class TextAdventure
  constructor: ->
    @world = new World()
    [@x, @y] = [0,0]

  quit: ->
    console.log "\n\nSo long, and thanks for all the fish"
    process.exit()

  dispatch: (action)->
    switch action
      when 'quit'
        @[action]()
      when "north", "south", "east", "west"
        console.log "\n\nYou travel #{action}"
        @go action
        @printStatus()
      when "look"
        @printStatus()
      else
        console.log "Sorry, I don't know what you mean by '#{action}'"

  printStatus: ->
    location = @world.getLocation @x, @y
    console.log "\nYou are at [#{@x}, #{@y}] - #{location[0]}"
    console.log location[1]
    console.log "\nYour surroundings: "
    surroundings = @world.surroundings(@x, @y)
    console.log "#{direction}: #{surroundings[direction][0]}" for direction of surroundings


  go: (direction) ->
    [@x, @y] = switch direction
      when 'north' then [@x, @y - 1]
      when 'south' then [@x, @y + 1]
      when 'east' then [@x + 1, @y]
      when 'west' then [@x - 1, @y]



  tryCommand: (command)=>
    command = command.trim().toLowerCase()
    @dispatch command
    console.log "\n\nWhere will you go next? >> "


adventure = new TextAdventure()

console.log 'Welcome to the text adventure, your available commands are north, south, east, west, look and quit'
adventure.tryCommand('look')

stdin.on 'data', adventure.tryCommand
