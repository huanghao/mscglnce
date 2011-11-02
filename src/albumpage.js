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

function show(title, url, albums) {
    $('.rec-sec').after(albums_div(title, url, albums));
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
