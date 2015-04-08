{$} = require 'atom-space-pen-views'

instance = null

class ImageRepository
  index: 0

  add: (path) ->
    paths = @getAll()
    unless path in paths
      paths.push path
      atom.config.set 'tree-view-background.imagePaths', paths

  get: ->
    paths = @getAll()
    return 'atom://tree-view-background/images/register-your-images.png' if paths.length is 0
    paths[if @index < paths.length then @index else paths.length - 1]

  getAll: ->
    paths = atom.config.get 'tree-view-background.imagePaths'
    if paths? then paths else []

  select: (path) ->
    paths = @getAll()
    i = paths.indexOf path
    @index = i if i >= 0

  show: ->
    $bg = $('.tree-view-background')
    if $bg.size() is 0
      $bg = $('<div>')
      $bg.addClass 'tree-view-background'
      $('.tree-view-scroller').before $bg

    $bg.css
      opacity: atom.config.get('tree-view-background.opacity')
      backgroundImage: "url(\"#{ @get() }\")"

  shuffle: ->
    len = @getAll().length
    return @index = 0 if len is 0
    @index += 1
    @index %= len

module.exports = do ->
  instance = new ImageRepository() unless instance?
  instance
