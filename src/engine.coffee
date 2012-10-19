class Engine

    constructor: (@tabid, request, backends) ->
        @sendback = request.sendback
        @backends = for b in backends
            new b(request.meta)

    next_backend: () ->
        @backend_i += 1
        @backend_url_i = 0

    next_backend_url: () ->
        @backend_url_i += 1
        if @backend_url_i >= @backends[@backend_i].urls.length
            @next_backend()

    search: () ->
        @backend_i = 0
        @backend_url_i = 0
        @_search()

    _search: () ->
        if @backend_i >= @backends.length
            return

        backend = @backends[@backend_i]
        url = backend.urls[@backend_url_i]
        that = this

        xhr = new XMLHttpRequest()
        xhr.open('GET', url, true)
        xhr.onreadystatechange = () ->
            if xhr.readyState == 4 && xhr.status == 200
                albums = backend.parse(xhr.responseText)
                if albums.length > 0
                    that.next_backend()
                    data =
                        sendback: that.sendback,
                        title: backend.title,
                        url: url,
                        albums: albums
                    chrome.tabs.sendRequest(that.tabid, data)
                else
                    that.next_backend_url()
                setTimeout('that._search()', 500)

        console.debug("SEARCH: #{url}")
        xhr.send()
