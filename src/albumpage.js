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
    var req = {info:getinfo()};
    chrome.extension.sendRequest(req);
}

function show(url, res) {
    var div = albums_div(res);
    div.prepend($('<h3>').append($('<a target="_blank">')
        .attr('href', url)
        .text('Albums from google.cn music')));

    $('.rec-sec').after(div);
}

chrome.extension.onRequest.addListener(function(request, sender, sendResponse) {
    show(request.url, request.res);
    sendResponse({});
});

fire();
