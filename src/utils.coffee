wget = (url, callback) -> # callback(responseText)
    xhr = new XMLHttpRequest()
    xhr.open('GET', url, true)
    xhr.onreadystatechange = () ->
        if xhr.readyState == 4 && xhr.status == 200
            console.debug "wget: callback: #{url}"
            callback(xhr.responseText)

    xhr.send()
    console.debug "wget: #{url}"

delay = (callback, time=500) ->
    setTimeout(callback, 500)

send2tab = (tabid, message) ->
    chrome.tabs.sendRequest(tabid, message)

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
