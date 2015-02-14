{View, TextEditorView} = require 'atom-space-pen-views'
repository             = require './image-repository'

module.exports =
class ImageUrlRegisterView extends View
  @content: ->
    @div =>
      @text 'Input image URL.'
      @subview 'urlView', new TextEditorView(mini: true, placeholderText: 'URL')
      @div class: 'block', =>
        @button 'cancel', class: 'btn', click: 'cancel'
        @button 'register', class: 'btn btn-primary pull-right', click: 'accept'
      @img outlet: 'image', click: 'accept'

  initialize: (path) ->
    atom.commands.add 'atom-workspace',
      'core:cancel': =>
        @hide()

    if path?
      @urlView.setText(path)
      @previewImage()

    @urlView.getModel().getBuffer().onDidChange =>
      @previewImage()

  show: ->
    @panel ?= atom.workspace.addModalPanel(item: this)
    @panel.show()
    @urlView.focus()

  hide: ->
    @panel?.destroy()
    @panel = null

  previewImage: ->
    url = @urlView.getText()
    @image
      .attr src: url
      .css
        maxWidth: '100%'
        maxHeight: '100%'

  accept: ->
    repository.add @urlView.getText()
    @hide()

  cancel: -> @hide()
