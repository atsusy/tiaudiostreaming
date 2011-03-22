// This is a test harness for your module
// You should do something interesting in this harness 
// to test out the module and to provide instructions 
// to users on how to use it by example.


// open a single window
var window = Ti.UI.createWindow({
	backgroundColor:'white'
});

// TODO: write your module tests here
var tiaudiostreaming = require('com.tiaudiostreaming');

var player = tiaudiostreaming.createPlayer();
player.url = "http://www9.nhk.or.jp/rj/podcast/mp3/20110313230100_1_1_english.mp3";


var start = Ti.UI.createButton({
	top:12,
	height:64,
	title:'start'
});
start.addEventListener('click', function(e){
	player.start();
});

var pause = Ti.UI.createButton({
	top:80,
	height:64,
	title:'pause'
});
pause.addEventListener('click', function(e){
	player.pause();
});

var stop = Ti.UI.createButton({
	top:150,
	height:64,
	title:'stop'
});
stop.addEventListener('click', function(e){
	player.stop();
});

window.add(start);
window.add(stop);
window.add(pause);

window.open();

