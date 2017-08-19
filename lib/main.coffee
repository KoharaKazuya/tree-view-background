CompositeDisposable   = undefined
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
    atom.packages.activatePackage('tree-view').then =>
      CompositeDisposable ?= require('event-kit').CompositeDisposable
      @disposables = new CompositeDisposable

      ImageRepository ?= require './image-repository'
      @repository = new ImageRepository
      @repository.index = state.index

      @disposables.add atom.config.observe(
        'tree-view-background.imagePaths', => @repository.show())
      @disposables.add atom.config.observe(
        'tree-view-background.opacity',    => @repository.show())

      @disposables.add atom.commands.add 'atom-workspace',
        'tree-view-background:select': => @select()
        'tree-view-background:shuffle': =>
          @repository.shuffle()
          @repository.show()
        'tree-view-background:register-image': => @registerImageUrl()

      @disposables.add atom.workspace.onDidOpen(() => @repository.show())

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
