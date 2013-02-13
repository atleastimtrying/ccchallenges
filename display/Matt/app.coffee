class Hugo
  constructor: (@json) ->
    @output = document.getElementById('display')

    @buildElements()
    @animate()

  buildElements: ->
    @output.innerHTML = @buildAssociativeOrArray(@json)


  buildAssociativeOrArray: (obj)->
    return @buildArray obj if @_isArray(obj)
    return @buildString obj if @_isString(obj)
    @buildAssociative obj

  buildAssociative: (hsh)->
    out = "<div>"
    out += "<section>" + @buildString(k) + @buildAssociativeOrArray(hsh[k]) + "</section>" for k of hsh
    out += "</div>"
    out

  buildString: (str)-> "<span>#{str}</span>"
  buildArray: (arr)->
    out = "<ul>"
    out += "<li> #{@buildAssociativeOrArray item} </li>" for item in arr
    out += "</ul>"
    out

  animate: ->


  _isArray: (obj)-> Object.prototype.toString.call( obj ) is '[object Array]'
  _isString: (obj)-> (typeof obj) is 'string'



launcher = ->
  new Hugo(window.my_json);


document.body.onload = launcher