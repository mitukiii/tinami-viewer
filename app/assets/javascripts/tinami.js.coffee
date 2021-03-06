class TINAMI
  @mobileinit: ->
    $m = $.mobile
    $m.loadingMessage = '読み込み中...'
    $m.pageLoadErrorMessage = '読み込みに失敗しました'

  @setImagePosition: ->
    img = $(this)
    height = img.height()
    width = img.width()
    return if height == 0 || width == 0
    img.css
      position: 'relative',
      top: ((130 - height) / 2) + 'px',
      left: ((130 - width) / 2) + 'px'

  @defaultHandler:
    beforeSend: (event) ->
      $.mobile.showPageLoadingMsg()
    success: (event, data) ->
      $.mobile.hidePageLoadingMsg()
    complete: (event, data) ->
      $.mobile.hidePageLoadingMsg()
    error: (event, data) ->
      $.mobile.hidePageLoadingMsg()
      alert(data.responseText)

  @actionHandler:
    success: (event, data) ->
      self = $(this)
      self.fadeOut 'fast', ->
        self.remove()

  @commentsHandler:
    success: (event, data) ->
      self = $(this)
      self.fadeOut 'fast', ->
        self.remove()
        return unless $.isPlainObject(data)
        comments = $('.comments').hide()
        data = data.comment
        if $.isArray(data)
          comments.append('<div class="comment">' + d + '</div>') for d in data
        else
          comments.append('<div class="comment">' + data + '</div>')
        comments.fadeIn 'fast'

  $d = $(document)
  $d.on('mobileinit', TINAMI.mobileinit)
  $d.on('pageshow', ->
    $('.hfeed .content .thumbnail img').
      each(TINAMI.setImagePosition).
      on('load', TINAMI.setImagePosition))
  for eventName, callback of TINAMI.defaultHandler
    $d.on('ajax:' + eventName, 'a[data-remote]', callback)
  for eventName, callback of TINAMI.actionHandler
    $d.on('ajax:' + eventName, '.support a, .collection-add a, .bookmark-add a', callback)
  for eventName, callback of TINAMI.commentsHandler
    $d.on('ajax:' + eventName, '.comments-load a', callback)
