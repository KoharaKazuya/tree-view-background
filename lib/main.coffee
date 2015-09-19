{CompositeDisposable} = require 'atom'
{$}                   = require 'atom-space-pen-views'
dialog                = (require 'remote').require 'dialog'
fileUrl               = require 'file-url'
ImageUrlRegisterView  = require './image-url-register-view'
ImageSelectView       = require './image-select-view'
repository            = require './image-repository'

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
    @disposables = new CompositeDisposable
    repository.index = state.index

    @disposables.add atom.config.observe(
      'tree-view-background.imagePaths', -> repository.show())
    @disposables.add atom.config.observe(
      'tree-view-background.opacity',    -> repository.show())

    $('body').on 'focus', '.tree-view', =>
      repository.show()
    $(=> repository.show())

    @disposables.add atom.commands.add 'atom-workspace',
      'tree-view-background:select': => @select()
      'tree-view-background:shuffle': ->
        repository.shuffle()
        repository.show()
      'tree-view-background:register-image-url': => @registerImageUrl()
      'tree-view-background:register-image-file': => @registerImageFile()

  deactivate: ->
    @disposables.dispose()

  serialize: -> {
    index: repository.index
  }

  select: ->
    (new ImageSelectView()).show()

  registerImageUrl: ->
    (new ImageUrlRegisterView()).show()

  registerImageFile: ->
    paths = dialog.showOpenDialog()
    if paths?.length > 0
      path = fileUrl(paths[0])
      (new ImageUrlRegisterView(path)).show()
