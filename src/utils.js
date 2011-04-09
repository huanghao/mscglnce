function albums_div(res) {
    var div = $('<div>');
    $.each(res, function(i, val) {
        console.debug(val.isrc);
        div.append($('<a target="_blank">').attr({'href':val.href, 'title':val.title+" "+val.tracks})
            .append($('<img class="gcnthumb">').attr({'src':val.isrc, 'alt':':('})));
    });
    return div;
}

