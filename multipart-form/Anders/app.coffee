class window.App
  constructor: ->
    $('#form').on 'submit', @submit
    $('#add').click @add
    $('.delete').live 'click', @remove

  submit: (event)=>
    event.preventDefault()
    data = {}
    data.people = []
    $('.person').each (index,element)=>
      name = $(element).find('.name').val()
      email = $(element).find('.email').val()
      age = $(element).find('.age').val()
      data.people.push
        name: name
        email: email
        age : age

    console.log data

  add: =>
    $('#people').append "<section class='person'>
          <input type='text' class='name' placeholder='name'>
          <input type='email' class='email' placeholder='email'>
          <input type='text' class='age' placeholder='age'>
          <button class='delete'>Delete</button>
        </section>"
  
  remove: (event)=>
    parent = $(event.currentTarget).parents('.person').fadeOut ->
      $(@).remove()
$ ->
  window.app = new App