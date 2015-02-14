{$}                  = require 'atom'
dialog               = (require 'remote').require 'dialog'
ImageUrlRegisterView = require './image-url-register-view'
ImageSelectView      = require './image-select-view'

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

    atom.commands.add 'atom-workspace', 'tree-view-background:select': => @select()
    atom.commands.add 'atom-workspace', 'tree-view-background:shuffle': => @shuffle()
    atom.commands.add 'atom-workspace', 'tree-view-background:register-image-url': => @registerImageUrl()
    atom.commands.add 'atom-workspace', 'tree-view-background:register-image-file': => @registerImageFile()

  serialize: -> @state

  select: ->
    (new ImageSelectView()).show()

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
      backgroundImage: "url(\"#{ path }\")"

  registerImageUrl: ->
    (new ImageUrlRegisterView()).show()

  registerImageFile: ->
    paths = dialog.showOpenDialog()
    if paths.length > 0
      (new ImageUrlRegisterView(paths[0])).show()
