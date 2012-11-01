add_search_buttons = ->
    console.debug "#1"
    $(".item").each (idx) ->
        console.debug idx
        intro = $('.info .title', this).text()
        arr = intro.split('/')
        if arr.length < 2
            return

        info =
            '{title_ch}': arr[0]
            '{title_en}': arr[1]

        a = $('<a href="#">')
            .attr('id', "gcnsearch#{idx}")
            .text("查询")
            .click () ->
                send2ext
                    meta: info
                    sendback: idx
                console.debug info
                false
        $('.gact', this).append("&nbsp;&nbsp;").append(a)

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
