sub = (tpl, info) ->
    m = tpl.match(/{.+?}/g)
    for i in m
        tpl = tpl.replace(i, encodeURIComponent(info[i]))
    tpl

sub_pages = (meta, pages) ->
    for page in pages
        sub(page, meta)

class XiaMi

    constructor: (meta) ->
        @urls = sub_pages(meta, [
            'http://www.xiami.com/search/album?key={title}+{表演者}',
            'http://www.xiami.com/search/album?key={title}',
            'http://www.xiami.com/search/album?key={表演者}'
            ])
        @title = "Albums from xiami.com"

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
            title = "<#{txt}> #{singer} #{year}"

            if $('span.unpub', this).length == 0
                data = 
                    href: "http://www.xiami.com#{href}"
                    img: img
                    title: title
                    tracks: tracks
                albums.push(data)
        albums
