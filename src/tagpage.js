function fire() {
    $("table").each(function(idx) {
        var title = $('.pl2', this).text().trim();
        var intro = $('.pl2', this).next('p.pl').text().split('/');
        var artist = intro[intro.length-1].trim();

        if (!title && !artist)
            return;
        var info = {
            '{title}': title,
            '{表演者}': artist
        };
        $('.gact', this).parent('p').append($('<a href="#">')
            .attr('class', 'gcnsearch'+idx)
            .text("查询")
            .click(function() {
                chrome.extension.sendRequest({meta:info, sendback:idx});
                return false;
            }));
    });
}

function show(idx, title, url, albums) {
    var gcnsearch = $(".gcnsearch"+idx);
    if (albums.length <= 0) {
        gcnsearch.after($("<strong>").text('无'));
    } else {
        gcnsearch.parents('table').after(albums_div(title, url, albums));
    }
}

chrome.extension.onRequest.addListener(function(request, sender, sendResponse) {
    var sendback = request.sendback;
    var title = request.title;
    var url = request.url;
    var albums = request.albums;
    show(sendback, title, url, albums);
    sendResponse({});
});

fire();
