var cloudfoundry = require('cloudfoundry');

var http = require('http');
http.createServer(function (req, res) {
  res.writeHead(200, {'Content-Type': 'text/plain'});
  res.end(cloudfoundry.host);
}).listen(8000, '127.0.0.1');

