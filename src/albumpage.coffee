send2ext = (message) ->
    chrome.extension.sendRequest message

get_info = () ->
    txt = $('#info').text()
    info = parse_kv txt
    info['{title}'] = $('h1 span').text().trim()
    info

create_album_list = (data) ->
    title = data.title
    url = data.url
    albums = data.albums

    div = $('<div class="mscglnce_albums">')

    a = $('<a target="_blank">').attr('href', url).text(title)
    h3 = $('<h3 class="title">').append a
    div.append h3

    for album in albums
        img = $('<img class="thumb">').attr
            src: album.img
            alt: album.title
        a = $('<a target="_blank">').attr
            href: album.href
            title: "#{album.title} #{album.tracks}"
        div.append a.append img
    div

show = (data) ->
    $('.rec-sec').after(create_album_list(data))

chrome.extension.onRequest.addListener (request, sender, sendResponse) ->
    sendResponse {}
    data = request
    show data

send2ext get_info()
