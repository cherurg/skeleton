var server = require('http').createServer();
var io = require('socket.io')(server);

io.on('connection', function (socket) {
  console.log('connected');
  var i = 0;
  socket.on('data', function (data) {
    console.log(i++);
    socket.broadcast.emit('data', data);
  });
  socket.on('disconnect', function () {
    console.log('disconnected');
  });
});

server.listen(80);