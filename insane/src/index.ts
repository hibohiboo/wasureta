

require('./styles.scss');

const { Elm } = require('./Main'); //  eslint-disable-line import/no-unresolved

const app = Elm.Main.init({ flags: 6 });

app.ports.toJs.subscribe((data) => {
  console.log(data);
});

// Use ES2015 syntax and let Babel compile it for you
// eslint-disable-next-line no-unused-vars
const testFn = (inp:number) => {
  const a = inp + 1;
  return a;
};
