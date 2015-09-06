m      = require 'mithril'
moment = require 'moment'
Shell  = require 'shell'

class TimelineBodyComponent
  constructor : (@_args) ->
    return {
      controller : ->
        _openExternal = (href) -> Shell.openExternal href

        _htmlDecode = (text) ->
          e = document.createElement 'div'
          e.innerHTML = text
          if e.childNodes.length is 0 then "" else e.childNodes[0].nodeValue

        decorateText : (text) =>
          strs =  text.split /(https?:\/\/\S+|\s\#\S+)/
          for str in strs
            if str.match(/https?:\/\/\S+/)
              m "a[href='#']", { onclick : _openExternal.bind this, str}, str
            else if str.match(/^\#|^\s\#/)
              m "a[href='#']", { onclick : _openExternal.bind this, str}, str
            else m "span", _htmlDecode(str)
      view : @_view
    }

  _view : (ctrl) =>
    m "div.timeline-wrapper", [
      m "div.timeline", @_args.items().map (item) =>
        m "div.mdl-grid.item.animated.fadeInUp", [
          m "div.mdl-cell.mdl-cell--1-col", [
            m "img.avatar", {src:item.tweet().user.profile_image_url}
          ]
          m "div.mdl-cell.mdl-cell--10-col.tweet-body", [
            m "span.name", item.tweet().user.name
            m "span.screen-name", "@#{item.tweet().user.screen_name}"
            m "span.time", moment(new Date(item.tweet().created_at)).format('lll')
            m "p.text",
            ctrl.decorateText item.tweet().text
            if item.tweet().entities?.media?
              m "div.image-wraper", [
                m "img.media", {src:item.tweet().entities.media[0].media_url}
              ]
            m "i.fa.fa-reply"
            m "i.fa.fa-star",
              class : if item.tweet().favorited then "on" else ""
              onclick : @_args.createFavorite.bind this, item
            m "i.fa.fa-retweet"
          ]
        ]
    ]

module.exports = TimelineBodyComponent
