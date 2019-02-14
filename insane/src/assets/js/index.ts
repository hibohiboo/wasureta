// import { Chart } from 'chart.js';
import { Elm } from './Main'; //  eslint-disable-line import/no-unresolved
require('../css/styles.scss'); // tslint:disable-line no-var-requires

const mountNode: HTMLElement = document.getElementById('main')!;
const app = Elm.Main.init({  node:mountNode, flags: 0 });

// app.ports.initialize.subscribe(() => {
// });
// app.ports.toJs.subscribe((data: number) => {
// });
