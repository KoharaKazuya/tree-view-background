{$, View}  = require 'atom-space-pen-views'
repository = require './image-repository'

module.exports =
class ImageSelectView extends View
  @content: ->
    @div =>
      @div class: 'tree-view-background-library', outlet: 'library'

  initialize: ->
    atom.commands.add 'atom-workspace',
      'core:cancel': =>
        @hide()

  show: ->
    @panel ?= atom.workspace.addModalPanel(item: this)
    @panel.show()

    @showContents()
    @resizeContents()

  hide: ->
    @panel?.destroy()
    @panel = null

  showContents: ->
    paths = atom.config.get('tree-view-background.imagePaths')
    return unless paths?

    paths.forEach (path) =>
      $div = $('<div>')
      $div.addClass 'tree-view-background-library-content'
      $div.css backgroundImage: "url(\"#{ path }\")"
      $div.on 'click', =>
        repository.select path
        repository.show()
        @hide()
      @library.append $div

  resizeContents: ->
    $tb = $('.tree-view-scroller')
    $contents = $('.tree-view-background-library-content')
    if $tb.size() > 0 and $contents.size() > 0
      $contents.width  Math.floor($tb.width()  * 2 / 3)
      $contents.height Math.floor($tb.height() * 2 / 3)
