{View} = require 'atom-space-pen-views'

module.exports =
class BackgroundView extends View
  @content: ->
    @div class: 'tree-view-background'

  attachView: () ->
    unless @treeView
      treeViewPackage = atom.packages.getActivePackage('tree-view')
      @treeView = treeViewPackage.mainModule.getTreeViewInstance()

    for other in document.querySelectorAll('.tree-view-background')
      other.parentNode.removeChild(other)
    @insertBefore @treeView.element

  setImage: (path) ->
    @attachView()
    @css backgroundImage: "url(\"#{ path }\")"

  setOpacity: (opacity) ->
    @attachView()
    @css opacity: opacity
