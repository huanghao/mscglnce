add_search_buttons = ->
    $("table").each (idx) ->
        pl2 = $('.pl2', this)
        title = pl2.text().trim().split('/')[0]
        intro = pl2.next('p.pl').text().split('/')
        artist = intro[intro.length-1].trim()

        info = '{title}': title
        if artist != ""
            info['{表演者}'] = artist

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
        $('.gact', this).parent('p').append("&nbsp;&nbsp;").append(span)

show = (data) ->
    albums = data.albums
    idx = data.sendback

    btn = $("#gcnsearch#{idx}")

    if data.albums.length <= 0
        btn.after($("<span>").text('None'))
    else
        div = create_album_list data
        btn.parents('table').after(div)
        btn.remove()

chrome.extension.onRequest.addListener (request, sender, sendResponse) ->
    sendResponse {}
    data = request
    show data

add_search_buttons()
