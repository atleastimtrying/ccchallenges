jQuery.fn.$_each = (func)->
  @each ->
    func.apply $(this)

class window.App
  constructor: ->
    @form = $('#form')
    @add_button = $('#add')
    @bindEvents()
    @blank_form = @people().first().clone()
    @blank_form.css 'display', 'none'

  bindEvents:() ->
    @form.on 'submit', @submit
    @add_button.click @add
    $('.delete').live 'click', @remove

  people: -> $('.person')

  submit: (event)=>
    event.preventDefault()
    data = []
    @people().$_each ->
      to_add = {}
      this.find('input').$_each ->
        to_add[this.attr('name')] = this.val()
      data.push to_add
    console.log data

  add: (event)=>
    event.preventDefault()
    person = @blank_form.clone()
    $('#people').append person
    person.fadeIn('slow')

  remove: (event)=>
    event.preventDefault()
    person = $(event.target).parents('.person')
    person.fadeOut =>
      person.remove()
      @add() if $('.person').length is 0

$ ->
  window.app = new App