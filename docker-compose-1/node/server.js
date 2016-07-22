'use strict';

var express  = require('express');
var app      = express();
var os 			 = require('os');

app.use('/*', function(req, res, next){
	res.setHeader("ContainerID", os.hostname());
  return next();
});

app.use(express.static(__dirname + '/public'));

app.listen(8080);
