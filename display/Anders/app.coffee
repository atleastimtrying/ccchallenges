class JSON
  constructor: (@app)->
    $.get 'people.json', @ready

  ready: (@json)=>
    $(@app).trigger 'ready', @json


class Display
  constructor: (@app)->
    @element = $ '#display'
    $(@app).bind 'ready', @buildDom

  buildDom: (event, json)=>
    for person in json.data
      @buildPerson person

  buildPerson:(json)=>
    div = $ '<div class="person">'
    @populatePerson json, div
    @element.append div

  populatePerson: (json, div)->
    for key,value of json
      div.append @buildString key,value if typeof value is 'string'
      div.append @buildObject key,value if typeof value is 'object'

  buildString: (key, string)->
    "<p><span>#{key}</span><span>#{string}</span></p>"

  buildObject: (key, object)->
    string = "<section><h3>#{key}</h1>"
    for key, value of object
      string += @buildString key,value if typeof value is 'string'
      string += @buildObject key,value if typeof value is 'object'
    string += '</section>'

class App
  constructor: ->
    @display = new Display @
    @json = new JSON @

$ ->
  window.app = new App