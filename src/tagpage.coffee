add_search_buttons = ->
    $("table").each (idx) ->
        td = $('td:last', this)
        pl2 = $('.pl2', td)
        pl = $('p.pl', td)
        if pl2.length < 1 or pl.length < 1
            return

        info = {}
        intro = pl.html().trim().replace(/<[^>]*>/, "\n").replace(/\uff1a/g, ":")
        arr = intro.split('/')
        if arr.length >= 5
            artist = arr[arr.length-1].trim()
            if artist != ""
                info['{表演者}'] = artist
        else
            info = parse_kv intro

        title = $('a', pl2).text().trim().split('/')[0]
        info['{title}'] = title

        a = $('<a href="#">')
            .attr('id', "gcnsearch#{idx}")
            .text("查询")
            .click () ->
                send2ext
                    meta: info
                    sendback: idx
                console.debug info
                false
        span = $('<span>').attr('class', 'gact').append(a)
        $('p:last', td).append("&nbsp;&nbsp;").append(span)

show = (data) ->
    albums = data.albums
    idx = data.sendback

    btn = $("#gcnsearch#{idx}")

    if data.albums.length <= 0
        btn.after($("<span>").text('None'))
    else
        div = create_album_list data
        btn.parents('p').after(div)
        btn.remove()

chrome.extension.onRequest.addListener (request, sender, sendResponse) ->
    sendResponse {}
    data = request
    show data

add_search_buttons()
