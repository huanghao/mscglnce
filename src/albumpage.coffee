String::endsWith = (suffix) ->
    this.indexOf(suffix, this.length - suffix.length) != -1


getinfo = () ->
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


fire = () ->
    chrome.extension.sendRequest meta: getinfo()

show = (title, url, albums) ->
    $('.rec-sec').after(albums_div(title, url, albums))

chrome.extension.onRequest.addListener (request, sender, sendResponse) ->
    sendback = request.sendback
    title = request.title
    url = request.url
    albums = request.albums
    show(title, url, albums)
    sendResponse({})

fire()
