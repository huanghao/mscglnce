function albums_div(title, url, albums) {
    var div = $('<div class="mscglnce_search_result">');
    $.each(albums, function(i, val) {
        div.append($('<a target="_blank">')
            .attr({'href':val.href, 'title':val.title+" "+val.tracks})
            .append($('<img class="thumb">')
                .attr({'src':val.img, 'alt':val.title})));
    });

    div.prepend($('<h3 class="title">').append($('<a target="_blank">')
        .attr('href', url)
        .text(title)));
    return div;
}
