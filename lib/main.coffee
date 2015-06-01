module.exports =
  config:
    showIcons:
      type: 'boolean'
      default: true
    alwaysShowTabBar:
      type: 'boolean'
      default: true
      description: "Shows the Tab Bar when only 1 tab is open"
    tabScrolling:
      type: 'boolean'
      default: process.platform is 'linux'
    tabScrollingThreshold:
      type: 'integer'
      default: 120
    enableVcsColoring:
      title: "Enable VCS Coloring"
      type: 'boolean'
      default: true

  activate: ->
    @tabBarViews = []

    TabBarView = require './tab-bar-view'
    _ = require 'underscore-plus'
    @paneSubscription = atom.workspace.observePanes (pane) =>
      tabBarView = new TabBarView(pane)

      paneElement = atom.views.getView(pane)
      paneElement.insertBefore(tabBarView.element, paneElement.firstChild)

      @tabBarViews.push(tabBarView)
      pane.onDidDestroy => _.remove(@tabBarViews, tabBarView)

  deactivate: ->
    @paneSubscription.dispose()
    tabBarView.remove() for tabBarView in @tabBarViews
