module.exports =
class ImageRepository
  constructor: ->
    @index = 0

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
    @backgroundView ?= new (require './background-view')
    @backgroundView.setImage @get()
    @backgroundView.setOpacity atom.config.get('tree-view-background.opacity')

  shuffle: ->
    len = @getAll().length
    return @index = 0 if len is 0
    @index += 1
    @index %= len
