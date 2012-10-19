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


class XiaMi

    constructor: (meta) ->
        queries = [
            'http://www.xiami.com/search/album?key={title}+{表演者}',
            'http://www.xiami.com/search/album?key={title}',
            'http://www.xiami.com/search/album?key={表演者}'
            ]
        @urls = format_urls(queries, meta)
        @title = "Albums from xiami.com"
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
                albums.push(data)
        albums
