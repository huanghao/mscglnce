function getinfo() {
    var info = {'{title}': $("h1 span").text().trim()};

    $("#info .pl").each(function() {
        var name = $(this).text().replace(':', '').trim();
        var next = $(this).nextUntil('br');
        var val = null;
        if (next.length > 0)
            val = $(next).text();
        else
            val = this.nextSibling.nodeValue;
        info['{'+name+'}'] = val.trim();
    });
    return info;
}

function fire() {
    var req = {meta: getinfo()};
    chrome.extension.sendRequest(req);
}

function albums_div(res) {
    var div = $('<div class="mscglnce_search_result">');
    $.each(res, function(i, val) {
        div.append($('<a target="_blank">').attr({'href':val.href, 'title':val.title+" "+val.tracks})
            .append($('<img class="thumb">').attr({'src':val.img, 'alt':':('})));
    });
    return div;
}

function show(title, url, albums) {
    var div = albums_div(albums);
    div.prepend($('<h3 class="title">').append($('<a target="_blank">')
        .attr('href', url)
        .text(title)));

    $('.rec-sec').after(div);
}

chrome.extension.onRequest.addListener(function(request, sender, sendResponse) {
    var sendback = request.sendback;
    var title = request.title;
    var url = request.url;
    var albums = request.albums;
    show(title, url, albums);
    sendResponse({});
});

fire();
