const Elm = require('../elm/characters/views/Main.elm');
const mountNode = document.getElementById('main');
const char = {
    name: "ごん", 
    image: {
      src: "/assets/images/gon.jpg"
    }
  };
const app = Elm.Main.embed(mountNode, JSON.stringify(char));
