m            = require 'mithril'
Tweetbox     = require './tweetbox-component'
TimelineBody = require './timelinebody-component'

class FavoriteComponent
  constructor : (vm, id) ->
    return {
      controller : (vm, id) -> vm.init()
      view : @_view
    }

  _view : (ctrl, vm, id) =>
    m "div.mdl-grid",  [
      m.component new Tweetbox
        tweetText : vm[id].tweetText
        onTweet   : vm[id].onTweet

      m.component new TimelineBody
        items      : vm[id].items.favorite
        onFavorite : vm[id].onFavorite
        onRetweet  : vm[id].onRetweet
    ]


module.exports = FavoriteComponent

