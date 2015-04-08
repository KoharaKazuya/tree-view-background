{$}                  = require 'atom-space-pen-views'
dialog               = (require 'remote').require 'dialog'
ImageUrlRegisterView = require './image-url-register-view'
ImageSelectView      = require './image-select-view'
repository           = require './image-repository'

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

  activate: (state) ->
    repository.index = state.index

    atom.config.observe 'tree-view-background.imagePaths', => repository.show()
    atom.config.observe 'tree-view-background.opacity',    => repository.show()

    $('body').on 'focus', '.tree-view', =>
      repository.show()
    $(=> repository.show())

    atom.commands.add 'atom-workspace', 'tree-view-background:select': => @select()
    atom.commands.add 'atom-workspace', 'tree-view-background:shuffle': =>
      repository.shuffle()
      repository.show()
    atom.commands.add 'atom-workspace', 'tree-view-background:register-image-url': => @registerImageUrl()
    atom.commands.add 'atom-workspace', 'tree-view-background:register-image-file': => @registerImageFile()

  serialize: -> {
    index: repository.index
  }

  select: ->
    (new ImageSelectView()).show()

  registerImageUrl: ->
    (new ImageUrlRegisterView()).show()

  registerImageFile: ->
    paths = dialog.showOpenDialog()
    if paths.length > 0
      (new ImageUrlRegisterView(paths[0])).show()
