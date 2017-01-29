{View, TextEditorView} = require 'atom-space-pen-views'
fileUrl                = require 'file-url'
dialog                 = require('electron').remote.dialog

dropHereImagePath = 'atom://tree-view-background/images/drop-here.png'

module.exports =
class ImageUrlRegisterView extends View
  @content: ->
    @div class: 'tree-view-background-registry', =>
      @div class: 'block', =>
        @text 'Input image URL'
        @subview 'urlView', new TextEditorView
          mini: true
          placeholderText: 'URL'
      @div class: 'block', =>
        @button 'Open',     class: 'btn btn-info',               click: 'open'
        @button 'Register', class: 'btn btn-primary pull-right', click: 'accept'
        @button 'Cancel',   class: 'btn btn-default pull-right', click: 'cancel'
      @div class: 'block', =>
        @img
          outlet: 'image'
          class: 'tree-view-background-registry-preview'
          click: 'accept'


  initialize: (@repository) ->
    atom.commands.add 'atom-workspace',
      'core:cancel': => @hide()

    @image.on 'dragenter', (e) => @eventCancel e
    @image.on 'dragover',  (e) => @eventCancel e
    @image.on 'drop',      (e) => @onDrop e

    @urlView.getModel().getBuffer().onDidChange =>
      @previewImage()

    @urlView.setText ''

  show: ->
    @panel ?= atom.workspace.addModalPanel(item: this)
    @panel.show()
    @urlView.focus()

  hide: ->
    @panel?.destroy()
    @panel = null

  previewImage: ->
    url = @urlView.getText()
    url = dropHereImagePath unless url? and (url isnt '')
    @image.attr src: url

  accept: ->
    path = @urlView.getText()
    @repository.add path if path isnt ''
    @hide()

  onDrop: (e) ->
    @eventCancel e
    files = e.originalEvent.dataTransfer.files
    return unless files.length > 0 and (file = files[0])?
    @urlView.setText fileUrl(file.path)

  open: ->
    paths = dialog.showOpenDialog()
    if paths?.length > 0
      path = fileUrl paths[0]
      @urlView.setText path

  cancel: ->
    @hide()

  eventCancel: (e) ->
    e.preventDefault()
    e.stopPropagation()
    false
