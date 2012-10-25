get_info = () ->
    txt = $('#info').text()
    info = parse_kv txt
    info['{title}'] = $('h1 span').text().trim()
    info

show = (data) ->
    $('.rec-sec').after(create_album_list(data))

chrome.extension.onRequest.addListener (request, sender, sendResponse) ->
    sendResponse {}
    data = request
    show data

send2ext meta: get_info()
