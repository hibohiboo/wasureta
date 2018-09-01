const Elm = require('../elm/characters/views/Main.elm');
const mountNode = document.getElementById('main');
const char = {
    name: "ごん", 
    image: {
      src: "/assets/images/gon.jpg",
      filename: "ごんぎつね",
      maker: "kyasaba",
      makerUrl: "https://www44.atwiki.jp/kyasaba/"
    },
    profile: "記憶喪失。覚えているのはごんという名前と、好物はおあげさんということ。",
    parameters: {
      str: 4,
      dex: 6,
      sense: 7,
      mind: 3,
      luck: 5,
      free: 10,
      freeName: "野生"
    }
  };
const app = Elm.Main.embed(mountNode, JSON.stringify(char));
