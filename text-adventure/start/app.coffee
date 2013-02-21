stdin = process.openStdin()
stdin.setEncoding 'utf8'

console.log 'outputted text'
stdin.on 'data', ->
  console.log "inputted text:#{text}"