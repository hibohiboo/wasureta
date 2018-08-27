var Elm = require('./elm/Main.elm');
const mountNode = document.getElementById('loginUser');
var app = Elm.Main.embed(mountNode);
