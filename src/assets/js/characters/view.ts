'use strict';

import * as Chart from 'chart.js';

const {Elm} = require('../elm/characters/views/Main.elm');
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
      free: 8,
      freeName: "野生"
    }
  };
const app = Elm.Main.init({node:mountNode, flags:JSON.stringify(char)});
app.ports.initialize.subscribe(()=>{
  const canvas = <HTMLCanvasElement> document.getElementById("myChart");
  const ctx = canvas.getContext("2d");

  const {str, dex, sense, mind, luck, free} = char.parameters;
  const data = {
    labels: ['肉体', '敏捷', '知覚', '精神', "幸運", "野生"],
    datasets: [{
        label: '能力値',
        data: [str, dex, sense, mind, luck, free],
        backgroundColor: [
          'rgba(255, 99, 132, 0.2)',
          'rgba(54, 162, 235, 0.2)',
          'rgba(255, 206, 86, 0.2)',
          'rgba(75, 192, 192, 0.2)',
          'rgba(153, 102, 255, 0.2)',
          'rgba(255, 159, 64, 0.2)'
      ],
      borderColor: [
          'rgba(255,99,132,1)',
          'rgba(54, 162, 235, 1)',
          'rgba(255, 206, 86, 1)',
          'rgba(75, 192, 192, 1)',
          'rgba(153, 102, 255, 1)',
          'rgba(255, 159, 64, 1)'
      ],
    }]
  };
  const myRadarChart = new Chart(ctx, {
    type: 'radar',
    data: data,
    options: {
      scale: {
        ticks: {
            suggestedMin: 0,
        }
    }
    }
  });
});
