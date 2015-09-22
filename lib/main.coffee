CompositeDisposable   = undefined
$                     = undefined
dialog                = undefined
fileUrl               = undefined
ImageUrlRegisterView  = undefined
ImageSelectView       = undefined
ImageRepository       = undefined

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
    CompositeDisposable ?= require('event-kit').CompositeDisposable
    @disposables = new CompositeDisposable

    ImageRepository ?= require './image-repository'
    @repository = new ImageRepository
    @repository.index = state.index

    @disposables.add atom.config.observe(
      'tree-view-background.imagePaths', => @repository.show())
    @disposables.add atom.config.observe(
      'tree-view-background.opacity',    => @repository.show())

    $ ?= require('atom-space-pen-views').$
    $('body').on 'focus', '.tree-view', => @repository.show()
    $(=> @repository.show())

    @disposables.add atom.commands.add 'atom-workspace',
      'tree-view-background:select': => @select()
      'tree-view-background:shuffle': =>
        @repository.shuffle()
        @repository.show()
      'tree-view-background:register-image-url': => @registerImageUrl()
      'tree-view-background:register-image-file': => @registerImageFile()

  deactivate: ->
    @disposables.dispose()

  serialize: -> {
    index: @repository.index
  }

  select: ->
    ImageSelectView ?= require './image-select-view'
    (new ImageSelectView(@repository)).show()

  registerImageUrl: ->
    ImageUrlRegisterView ?= require './image-url-register-view'
    (new ImageUrlRegisterView(@repository)).show()

  registerImageFile: ->
    dialog ?= (require 'remote').require 'dialog'
    paths = dialog.showOpenDialog()
    if paths?.length > 0
      fileUrl ?= require 'file-url'
      path = fileUrl(paths[0])
      ImageUrlRegisterView ?= require './image-url-register-view'
      (new ImageUrlRegisterView(@repository, path)).show()
