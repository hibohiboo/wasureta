// import { Chart } from 'chart.js';
import { Elm } from './Main'; //  eslint-disable-line import/no-unresolved
require('../css/styles.scss'); // tslint:disable-line no-var-requires

const mountNode: HTMLElement = document.getElementById('main')!;

// ローカルストレージから前回値を読み出し
const flags: string = localStorage.insaneHandouts === undefined ? "" : localStorage.insaneHandouts;

// 前回値を初期値として与える
const app = Elm.Main.init({  node:mountNode, flags });

// app.ports.initialize.subscribe(() => {
// });
app.ports.toJs.subscribe((data: string) => {
  localStorage.insaneHandouts = data;
});
