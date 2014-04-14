squares = angular.module "squares", []

# Note: "keystone" refers to the the square's left edge. When discussing squares,
# the coords given will be the keystone's coordinates.

squares.controller "squares-controller", ['$scope', ($scope)->
  $scope.num_players = parseInt prompt("How many people are playing?", 2), 10
  $scope.players = [1..$scope.num_players]
  $scope.current_player = 1
  $scope.selected = {}
  $scope.won = {}

  getLineOwner = (type, row, cell)-> $scope.selected[row + type + cell]
  isLineSelected = (type, row, cell)-> getLineOwner(type, row, cell)?
  setLineSelected = (type, row, cell)-> $scope.selected[row + type + cell] = $scope.current_player
  getSquareWinner = (row, cell)-> $scope.won[row + '/' + cell]
  isSquareWon = (row, cell)-> getSquareWinner(row, cell)?
  setSquareWon = (row, cell)-> $scope.won[row + '/' + cell] = $scope.current_player

  nextPlayer = ->
    $scope.current_player += 1
    $scope.current_player = 1 if $scope.current_player == $scope.num_players + 1

  isSquareNewlyWon = (row, cell)->
    return false if getSquareWinner(row, cell)
    return true if isLineSelected('v', row, cell) && isLineSelected('h', row, cell) &&
      isLineSelected('v', row, cell + 1) && isLineSelected('h', row + 1, cell)
    return false

  getNearbyKeystones = (type, row, cell)->
    return [[row, cell-1], [row, cell]] if type is 'v'
    [[row-1, cell], [row, cell]]

  updateWinnings = (type, row, cell)->
    won = false
    for keystone in getNearbyKeystones(type, row, cell)
      if isSquareNewlyWon(keystone...)
        setSquareWon(keystone...)
        won = true
    won

  choose = (type, row, cell)->
    return if isLineSelected type, row, cell
    setLineSelected type, row, cell
    nextPlayer() unless updateWinnings type, row, cell

  $scope.chooseVertical = (row, cell)-> choose 'v', row, cell
  $scope.chooseHorizontal = (row, cell)-> choose 'h', row, cell

  wonClass = (row, cell)->
    'p' + getSquareWinner(row, cell) + '-won'

  $scope.hCssClass = (row, cell)->
    'p' + getLineOwner('h', row, cell)

  $scope.vCssClass = (row, cell)->
    wonClass(row, cell) + ' ' +
      'p' + getLineOwner('v', row, cell)

]
