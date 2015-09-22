{View} = require 'atom-space-pen-views'

module.exports =
class BackgroundView extends View
  @content: ->
    @div class: 'tree-view-background'

  initialize: ->
    treeViewPackage = atom.packages.getActivePackage('tree-view')
    treeView = treeViewPackage.mainModule.createView()

    treeView.find('.tree-view-background').remove()
    treeView.prepend @

  setImage: (path) ->
    @css backgroundImage: "url(\"#{ path }\")"

  setOpacity: (opacity) ->
    @css opacity: opacity
