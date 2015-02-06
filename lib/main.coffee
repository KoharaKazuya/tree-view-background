{$} = require 'atom'

module.exports =

  config:
    imagePaths:
      type: 'array'
      default: []
      items:
        type: 'string'
    opacity:
      type: 'number'
      default: 0.2

  activate: (@state) ->
    atom.config.observe 'tree-view-background.imagePaths', => @setBackgroundImage()
    atom.config.observe 'tree-view-background.opacity', => @setBackgroundImage()

    $('body').on 'focus', '.tree-view', =>
      @setBackgroundImage()
    $(=> @setBackgroundImage())

    atom.commands.add 'atom-workspace', 'tree-view-background:shuffle': => @shuffle()

  serialize: -> @state

  shuffle: ->
    if @state.index?
      paths = atom.config.get('tree-view-background.imagePaths')
      @state.index += 1
      @state.index %= paths.length
    else
      @state.index = 0

    @setBackgroundImage()

  setBackgroundImage: ->
    @shuffle() unless @state.index?

    paths = atom.config.get('tree-view-background.imagePaths')
    path = if paths.length is 0
      ''
    else
      @state.index = Math.min(@state.index, paths.length - 1)
      paths[@state.index]

    $bg = $('.tree-view-background')

    if $bg.size() is 0
      $bg = $('<div>')
      $bg.addClass 'tree-view-background'
      $('.tree-view-scroller').before $bg

    $bg.css
      opacity: atom.config.get('tree-view-background.opacity')
      backgroundImage: "url(\"file://#{ path }\")"
