var express = require('express');
var bodyParser = require('body-parser')
var mongoose = require('mongoose');

var app = express();
var http = require('http').Server(app);
var io = require('socket.io')(http);

app.use(express.static(__dirname));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended: false}))

//Object of parameters for Insert on MongoDB
var Message = mongoose.model('Message',{
  id : Number,
  name : String,
  message : String
})

//URL to connect with MongoDB
var dbUrl = 'mongodb+srv://ezops-test:acAoIf9CQF5S4SBG@ezops-test.rvwtz.mongodb.net/ezops-test?retryWrites=true&w=majority'

//Get Method. Get all the messages in MongoDB
app.get('/messages', (req, res) => {
  Message.find({},(err, messages)=> {
    res.send(messages);
  })
})

//Post a Name and a Message on MongoBD
app.post('/messages', (req, res) => {
  var message = new Message(req.body);
  message.save((err) =>{
    if(err)
      sendStatus(500);
    io.emit('message', req.body);
    res.sendStatus(200);
  })
})

io.on('connection', () =>{
  console.log('a user is connected')
})
mongoose.connect(dbUrl ,(err) => {
  console.log('mongodb connected! Errors:',err);
})
var server = http.listen(3000, () => {
  console.log('server is running on port', server.address().port);
});