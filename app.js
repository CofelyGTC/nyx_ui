//|-
//|- Customer Console Server
//|-


var http = require('http');
var express = require('express');
var app = express();
var path="/etc/opt/nyx_ui"

//var cors = require('cors');
console.log("Path:"+path)
app.use(express.static(path));
//app.use(cors())


//************** HTTP *************

/*app.use(function(req, res, next) {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Credentials', true);
  res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept');
  res.header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, DELETE');
  next();
  });
  
  app.use(bodyParser.urlencoded({ extended: true }))
  
  app.use(bodyParser.json())*/
app.get('/version', function (req, res) {
  if (!process.env.VERSION) {
    return res.status(500).json({ error: "Version number not set" });
  }
  res.json({ version: process.env.VERSION });
});

var server = app.listen(7654, function () {

  var host = server.address().address
  host = '0.0.0.0'
  var port = server.address().port

  console.log("Front Server app listening at http://%s:%s", host, port)

})


console.log("Bye bye")
