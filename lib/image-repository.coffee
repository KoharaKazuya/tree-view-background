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
    atom.packages.activatePackage('tree-view').then =>
      treeView = atom.packages.getActivePackage('tree-view').mainModule.createView()
      treeViewElement = atom.views.getView treeView

      candidates = treeViewElement.getElementsByClassName 'tree-view-background'
      bg = if candidates.length > 0
        candidates[0]
      else
        bg = document.createElement 'div'
        bg.className = 'tree-view-background'
        treeViewElement.appendChild bg
        bg

      bg.setAttribute 'style', """
        opacity: #{ atom.config.get 'tree-view-background.opacity' };
        background-image: url("#{ @get() }");
      """

  shuffle: ->
    len = @getAll().length
    return @index = 0 if len is 0
    @index += 1
    @index %= len
