const Elm = require('../elm/characters/views/Main.elm');
const mountNode = document.getElementById('main');
const app = Elm.Main.embed(mountNode, JSON.stringify({name: "ごん"}));
