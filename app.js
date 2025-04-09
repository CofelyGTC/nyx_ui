//|-
//|- Customer Console Server
//|-


const cors = require('cors');
var http = require('http');


var express = require('express');
var app = express();
var path="/dist"
console.log("Path:"+path)
app.use(express.static(path));
app.use(cors()); // Cela permettra toutes les origines, à utiliser avec précaution


//************** HTTP *************

var server = app.listen(8080, function () {
  var host = server.address().address
  host = '0.0.0.0'
  var port = server.address().port

  console.log("Front Server app listening at http://%s:%s", host, port)
})


console.log("Bye bye")
