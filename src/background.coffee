class XiaMi
    constructor: (meta) ->
        queries = [
            'http://www.xiami.com/search/album?key={title}+{表演者}',
            'http://www.xiami.com/search/album?key={title}',
            'http://www.xiami.com/search/album?key={表演者}'
            ]
        @urls = format_urls(queries, meta)
        @title = "xiami.com 在线试听"
        console.debug meta
        console.debug @urls

    parse: (responseText) ->
        html = $(responseText)
        albums = []
        $('div.album_item100_block', html).each () ->
            href = $('.cover a', this).attr('href')
            img = $('.cover img', this).attr('src')
            tracks = $('.album_rank em', this).text()

            name = $('.name a:first', this).text()
            singer = $('.name .singer', this).text()
            year = $('.year', this).text()
            title = "<#{name}> #{singer} #{year}"

            if $('span.unpub', this).length == 0
                data = 
                    href: "http://www.xiami.com#{href}"
                    img: img
                    title: title
                    tracks: tracks
                albums.push data
        albums


tasks = []

add_task = (msg, sender) ->
    for cls in [XiaMi]
        backend = new cls(msg)
        for url in backend.urls
            task =
                url: url
                parser: backend.parse
                tabid: sender.tab.id
                title: backend.title
            tasks.push task

run = ->
    if tasks.length == 0
        return

    task = tasks.shift()

    wget task.url, (responseText) ->
        albums = task.parser responseText
        if albums? and albums.length > 0
            data =
                title: task.title
                url: task.url
                albums: albums

            #TODO, only remove all urls from some site
            tasks = []
            send2tab task.tabid, data
        else
            delay run


chrome.extension.onRequest.addListener (request, sender, sendResponse) ->
    sendResponse {}
    add_task request, sender
    delay run
