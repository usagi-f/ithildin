m                 = require 'mithril'
jsonfile          = require 'jsonfile'
PubSub            = require 'pubsub-js'
TimelineViewModel = require './js/timeline'
TimelineComponent = require './js/timeline-component'
Search            = require './js/search-component'
Favorite          = require './js/favorite-component'
SideMenu          = require './js/sidemenu-component'
Twitter           = require './js/twitter-client'

global.timelineChannels = ["home", "favorite", "search"]

class IthildinMain
  constructor : ->
    m.route.mode = "hash"
    accountId = m.prop 0
    @_accounts = m.prop jsonfile.readFileSync 'accounts.json'
    @_timelineViewModels = for account in @_accounts() then new TimelineViewModel(account)
    timelineComponents = for channel in timelineChannels
      m.component new TimelineComponent(), @_timelineViewModels, {
        accountId : accountId
        channel   : channel
      }

    m.route document.getElementById("timeline"), "/home", {
      "/home"     : timelineComponents.home
      "/favorite" : timelineComponents.favorite
      "/search"   : timelineComponents.search
    }

    sidemenu = m.component new SideMenu(), accounts, accountId
    m.mount document.getElementById("side-menu"), sidemenu

    #PubSub.subscribe "accounts.onchange", (msg, id) =>
    #  accountId id

    ipc.on 'authenticate-request-reply', => @_addAccount()

  _addAccount : =>
    @_accounts = m.prop jsonfile.readFileSync 'accounts.json'
    @_timelineViewModels.push new TimelineViewModel(@_accounts.last())

new IthildinMain()
