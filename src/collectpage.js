function fire() {
    $(".grid-view .info").each(function(idx) {
        var title = $('.title', this).text().trim();
        var intro = $('.intro', this).text().split('/');
        var artist = intro[intro.length-1].trim();

        var info = {
            '{title}': title,
            '{表演者}': artist
        };

        $('.gact', this).append($('<a href="#">')
            .attr('class', 'gcnsearch')
            .text("查询")
            .click(function() {
                chrome.extension.sendRequest({info:info, sendback:idx});
                return false;
            }));
    });
}

function show(idx, url, res) {
    var infodiv = $(".grid-view .info").eq(idx);
    var gcnsearch = $('.gcnsearch', infodiv);
    if (res.length <= 0) {
        gcnsearch.after($("<strong>").text('无'));
    } else {
        $(infodiv).append(albums_div(res));
    }
    gcnsearch.remove();
}

chrome.extension.onRequest.addListener(function(request, sender, sendResponse) {
    show(request.sendback, request.url, request.res);
    sendResponse({});
});

fire();
