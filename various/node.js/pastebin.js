var http = require('http'),
    url = require('url'),
    querystring = require('querystring')
paste_code = ''
process.stdin.resume()
process.stdin.on('data', function(data) {paste_code+=data;})
process.stdin.on('end', function() {
    console.log(paste_code);
    var post_data = querystring.stringify({
        api_dev_key: '3df6aae59d5d9c9e0e87438b0e0b7ecd',
        api_option: 'paste',
        api_paste_code: paste_code});
    console.log(post_data);
    console.log(post_data.length);
    var options = {
        host: 'pastebin.com',
        method: 'POST',
        path: '/api/api_post.php',
        headers: {
            'Content-Length': post_data.length,
            'Content-Type': 'application/x-www-form-urlencoded'
        }
    };
    http.request(options, function (res) {
        res.pipe(process.stdout);
    }).end(post_data, 'utf8');
});
