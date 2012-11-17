add_search_buttons = ->
    $(".grid-view .info").each (idx) ->
        title = $('.title', this).text().trim().split('/')[0].trim()
        intro = $('.intro', this).text().trim().split('/')
        artist = intro[intro.length-1].trim()

        info =
            '{表演者}': artist
            '{title}': title

        a = $('<a href="#">')
            .attr('id', "gcnsearch#{idx}")
            .text("查询")
            .click () ->
                send2ext
                    meta: info
                    sendback: idx
                console.debug info
                false

        $('.gact', this).append(a)


show = (data) ->
    console.debug data
    albums = data.albums
    idx = data.sendback

    btn = $("#gcnsearch#{idx}")

    if data.albums.length <= 0
        btn.after($("<span>").text('None'))
    else
        div = create_album_list data
        btn.parents('li').after(div)
        btn.remove()

chrome.extension.onRequest.addListener (request, sender, sendResponse) ->
    sendResponse {}
    data = request
    show data

add_search_buttons()
