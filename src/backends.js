function sub(tpl, info) {
    var m = tpl.match(/{.+?}/g);
    for (var i in m)
        tpl = tpl.replace(m[i], encodeURIComponent(info[m[i]]));
    return tpl;
}

function sub_pages(meta, pages) {
    var urls = [];
    for (var i in pages) 
        urls.push(sub(pages[i], meta));
    return urls; 
}

function GCN(meta) {
    this.urls = sub_pages(meta, [
        'http://www.google.cn/music/search?q={title}+{表演者}&cat=album',
        'http://www.google.cn/music/search?q={表演者}&cat=album'
    ]);
    this.title = 'Albums from google.cn/music';
}

GCN.prototype.parse = function(responseText) {
    var html = $(responseText);
    var albums = [];
    $('.AlbumItem', html).each(function() {
        var href = $('.thumb a', this).attr('href');
        var img = $('.thumb img', this).attr('src');
        var title = $('.Title a', this).first().text();
        var tracks = $('.Tracks', this).text();
        albums.push({
            href: 'http://www.google.cn'+href,
            img: img,
            title: title,
            tracks: tracks
        });
    });
    return albums;  
}
 
function XiaMi(meta) {
    this.urls = sub_pages(meta, [
        'http://www.xiami.com/search/album?key={title}+{表演者}',
        'http://www.xiami.com/search/album?key={表演者}'
    ]);
    this.title = 'Albums from xiami.com';
}

XiaMi.prototype.parse = function(responseText) {
    var html = $(responseText);
    var albums = [];
    $('p.cover', html).each(function() {
        var href = $('a', this).attr('href');
        var title = $('a', this).attr('title');
        var img = $('img', this).attr('src');
        albums.push({
            href: 'http://www.xiami.com'+href,
            img: img,
            title: title
        });
    });
    return albums;
}
