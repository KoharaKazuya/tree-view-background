module.exports =
class ImageRegistry
  register: (url) ->
    paths = @getPaths()
    unless url in paths
      paths.push url
      @setPaths paths

  getPaths: -> atom.config.get 'tree-view-background.imagePaths'

  setPaths: (paths) ->
    atom.config.set 'tree-view-background.imagePaths', paths
