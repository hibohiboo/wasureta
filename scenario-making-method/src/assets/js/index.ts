// import { Chart } from 'chart.js';
import { Elm } from './Main'; //  eslint-disable-line import/no-unresolved
require('../css/styles.scss'); // tslint:disable-line no-var-requires

// ローカルストレージに保存するためのキー
const STORAGE_KEY = "insaneHandouts";

// elmのＤＯＭを作成する元となるＤＯＭ要素
const mountNode: HTMLElement = document.getElementById('main')!;

// ローカルストレージから前回値を読み出し
const flags: string = localStorage[STORAGE_KEY] === undefined ? "" : localStorage.insaneHandouts;

// 前回値を初期値として与える
const app = Elm.Main.init({  node:mountNode, flags });

// app.ports.initialize.subscribe(() => {
// });
app.ports.toJs.subscribe((data: string) => {
  console.log(data)
  // localStorage[STORAGE_KEY] = data;

  // // 本文がなければ、ストレージから削除してしまう
  // if(data.trim().length == 0){
  //   localStorage.removeItem(STORAGE_KEY);  
  // }
});
function save(){
  console.log('click')
  var svg = document.querySelector("svg"); // tslint:disable-line
  if(svg == null){return;}
  var svgData = new XMLSerializer().serializeToString(svg);
  var canvas = document.createElement("canvas"); 
  console.log(svg)
  canvas.width = svg.width.baseVal.value;
  canvas.height = svg.height.baseVal.value;
  
  var ctx = canvas.getContext("2d"); 
  var image = new Image; 
  image.onload = function(){
    if(ctx==null) return;
    console.log(ctx)
      ctx.drawImage( image, 0, 0 ); 
      var a = document.createElement("a");
      a.href = canvas.toDataURL("image/png");
      a.setAttribute("download", "image.png");
      a.dispatchEvent(new MouseEvent("click"));
      console.log(a)
  }
  image.src = "data:image/svg+xml;charset=utf-8;base64," + btoa(unescape(encodeURIComponent(svgData))); 
}
var button = document.getElementById('save')
if(button){button.addEventListener('click', save);}