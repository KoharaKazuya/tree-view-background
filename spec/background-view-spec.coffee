{View}         = require 'atom-space-pen-views'
BackgroundView = require '../lib/background-view'

describe 'BackgroundView', ->
  instance = undefined

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage('tree-view')
    runs ->
      instance = new BackgroundView

  it 'has "tree-view-background" class', ->
    expect(instance.hasClass('tree-view-background')).toBeTrue

  it 'sets the element as a tree-view\'s child', ->
    treeViewPackage = atom.packages.getActivePackage('tree-view')
    treeView = treeViewPackage.mainModule.createView()
    treeViewElement = atom.views.getView treeView

    elements = treeViewElement.getElementsByClassName 'tree-view-background'
    expect(elements.length).toBe 1

  it 'creates only one DOM element', ->
    new BackgroundView
    new BackgroundView

    treeViewPackage = atom.packages.getActivePackage('tree-view')
    treeView = treeViewPackage.mainModule.createView()
    treeViewElement = atom.views.getView treeView
    elements = treeViewElement.getElementsByClassName 'tree-view-background'
    expect(elements.length).toBe 1

  it 'can set an image', ->
    instance.setImage 'abc'

  it 'can set opacity', ->
    instance.setOpacity 0.1
