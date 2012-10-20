String::endsWith = (suffix) ->
    this.indexOf(suffix, this.length - suffix.length) != -1

send2ext = (message) ->
    chrome.extension.sendRequest message

get_info = () ->
    info =
        '{title}': $('h1 span').text().trim()

    lines = (i.trim() for i in $('#info').text().trim().split('\n'))
    lines = (i for i in lines when i.length > 0)

    continue_ = false
    new_lines = []

    for line in lines
        if continue_
            new_lines[new_lines.length-1] += line
            continue_ = false
        else
            if line.endsWith(':')
                continue_ = true
            new_lines.push line

    for line in new_lines
        [name, val] = ( i.trim() for i in line.split(':', 2))
        info["{#{name}}"] = val

    console.debug info
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
