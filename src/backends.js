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
        'http://www.google.cn/music/search?q={title}&cat=album',
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
        'http://www.xiami.com/search/album?key={title}',
        'http://www.xiami.com/search/album?key={表演者}'
    ]);
    this.title = 'Albums from xiami.com';
}

XiaMi.prototype.parse = function(responseText) {
    var html = $(responseText);
    var albums = [];
    $('div.album_item100_block', html).each(function() {
        var href = $('.cover a', this).attr('href');
        var img = $('.cover img', this).attr('src');
        var title = "<" + $('.name a:first', this).text() +"> " + 
            $('.name .singer', this).text() + ' ' + $('.year', this).text();
        var tracks = $('.album_rank em', this).text();
        if ($('span.unpub', this).length == 0) {
            albums.push({
                href: 'http://www.xiami.com'+href,
                img: img,
                title: title,
                tracks: tracks
            });
        }
    });
    return albums;
}

function Ting(meta) {
    this.urls = sub_pages(meta, [
        'http://ting.baidu.com/search?key={title}+{表演者}',
        'http://ting.baidu.com/search?key={title}',
        'http://ting.baidu.com/search?key={表演者}',
    ]);
    this.title = 'Albums from ting.baidu.com'
}
Ting.prototype.parse = function(responseText) {
    var html = $(responseText);
    var albums = [];
    var addr = [];
    var img = '#';
    $('a.cover', html).each(function() {
        img = $('img', this).attr('org_src');
    });
    $('span.album-title a', html).each(function() {
        var href = $(this).attr('href');
        var title = $(this).text()
        var al = {
            href: 'http://ting.baidu.com'+href,
            title: title,
            img: img,
            tracks: ''
        };
        if (addr.indexOf(href)<0) {
            addr.push(href)
            albums.push(al);
        }
    });
    return albums;
}
