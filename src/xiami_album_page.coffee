get_info = ->
    title = $('#title h1').text()
    txt = $('#album_info table').text()
    info = parse_kv(txt)
    console.debug info

get_info()
