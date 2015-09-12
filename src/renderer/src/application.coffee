m                 = require 'mithril'
jsonfile          = require 'jsonfile'
ipc               = require 'ipc'
TimelineViewModel = require './js/timeline-viewmodel'
TimelineComponent = require './js/timeline-component'
SideMenu          = require './js/sidemenu-component'

global.timelineChannels = ["home", "favorite", "search"]

class IthildinMain
  constructor : ->
    m.route.mode = "hash"
    accountId = m.prop 0
    @_accounts = m.prop jsonfile.readFileSync 'accounts.json'
    @_timelineViewModels = for account in @_accounts() then new TimelineViewModel(account)
    timelineComponents = {}

    for channel in timelineChannels
      timelineComponents[channel] =
        m.component new TimelineComponent(), @_timelineViewModels, {
          accountId : accountId
          channel   : channel
        }

    m.route document.getElementById("timeline"), "/home", {
      "/home"     : timelineComponents.home
      "/favorite" : timelineComponents.favorite
      "/search"   : timelineComponents.search
    }

    sidemenu = m.component new SideMenu(), @_accounts, accountId
    m.mount document.getElementById("side-menu"), sidemenu

    ipc.on 'authenticate-request-reply', => @_addAccount()

  _addAccount : =>
    @_accounts = m.prop jsonfile.readFileSync 'accounts.json'
    @_timelineViewModels.push new TimelineViewModel(@_accounts.last())

new IthildinMain()