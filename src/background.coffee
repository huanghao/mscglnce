class XiaMi
    constructor: (meta) ->
        @title = "music from xiami.com"
        queries = [
            'http://www.xiami.com/search/album?key={title}+{表演者}',
            'http://www.xiami.com/search/album?key={title}',
            'http://www.xiami.com/search/album?key={表演者}'
            ]
        @urls = format_urls(queries, meta)
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
                    href: "#{href}"
                    img: img
                    title: title
                    tracks: tracks
                albums.push data
        albums


class Engine
    constructor: (request, sender) ->
        @tasks = []
        @sendback = request.sendback ? {}
        @add_task(request.meta, sender)

    add_task: (meta, sender) =>
        for cls in [XiaMi]
            backend = new cls(meta)
            for url in backend.urls
                task =
                    url: url
                    parser: backend.parse
                    tabid: sender.tab.id
                    title: backend.title
                @tasks.push task

    run: =>
        if @tasks.length == 0
            return

        task = @tasks.shift()

        that = this
        wget task.url, (responseText) ->
            albums = task.parser responseText
            if albums? and albums.length > 0
                data =
                    title: task.title
                    url: task.url
                    albums: albums
                    sendback: that.sendback

                #TODO, only remove all urls from some site
                that.tasks = []
                send2tab task.tabid, data
            else
                delay that.run


chrome.extension.onRequest.addListener (request, sender, sendResponse) ->
    sendResponse {}
    engine = new Engine(request, sender)
    delay engine.run
