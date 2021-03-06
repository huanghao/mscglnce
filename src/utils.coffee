wget = (url, callback) -> # callback(responseText)
    xhr = new XMLHttpRequest()
    xhr.open('GET', url, true)
    xhr.onreadystatechange = () ->
        if xhr.readyState == 4 && (xhr.status >= 200 && xhr.status < 300 || xhr.status == 304)
            console.debug "wget: callback: #{url}"
            callback(xhr.responseText)

    xhr.send()
    console.debug "wget: #{url}"

delay = (callback, time=500) ->
    setTimeout(callback, 500)

send2tab = (tabid, message) ->
    chrome.tabs.sendRequest(tabid, message)

send2ext = (message) ->
    chrome.extension.sendRequest message

format = (string, dict) ->
    for name in string.match(/{.+?}/g)
        if not (name of dict) or dict[name] == ''
            throw 'TypeError: not enough arguments for format string'
        string = string.replace(name, encodeURIComponent(dict[name]))
    string

format_urls = (links, meta) ->
    urls = []
    for link in links
        try
            url = format link, meta
        catch error
            continue
        urls.push url
    urls

String::endsWith = (suffix) ->
    this.indexOf(suffix, this.length - suffix.length) != -1

parse_kv = (txt) ->
    txt = txt.replace(/\uff1a/g, ":")
    lines = (i.trim() for i in txt.trim().split('\n'))
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

    info = {}

    for line in new_lines
        [name, val] = ( i.trim() for i in line.split(':', 2))
        info["{#{name}}"] = val

    info


create_album_list = (data) ->
    title = data.title
    url = data.url
    albums = data.albums

    div = $('<div class="gcn_albums">')

    a = $('<a target="_blank">').attr('href', url).text(title)
    h3 = $('<h3 class="gcn_album_title">').append a
    div.append h3

    for album in albums
        img = $('<img class="gcn_album_thumb">').attr
            src: album.img
            alt: album.title
        a = $('<a target="_blank">').attr
            href: album.href
            title: "#{album.title} #{album.tracks}"
        div.append a.append img
    div
