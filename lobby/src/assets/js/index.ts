
// import * as M from 'M'; //  tslint-disable-line
import { Elm } from './Main'; //  eslint-disable-line import/no-unresolved
import { lobbyRef } from './firebase/firebase';
import * as moment from 'moment';

require('../css/styles.scss'); // tslint:disable-line no-var-requires


const flags = {};

// elmのＤＯＭを作成する元となるＤＯＭ要素
const mountNode: HTMLElement = document.getElementById('chatlog')!;

// 初期値を与える
const app = Elm.Main.init({ node: mountNode, flags });

lobbyRef.orderBy('createdAt', 'desc').limit(20).onSnapshot(qs => {
  qs.docChanges().reverse().forEach(change => {
    if ('added' !== `${change.type}`) {
      return;
    }
    const data = change.doc.data();

    app.ports.addChat.send({
      name: data.common.name,
      text: data.common.text,
      createdAt: moment(data.createdAt.seconds * 1000).format("YYYY-MM-DD HH:mm:ss")//.toISOString()
    });
  });
});
app.ports.errorToJs.subscribe(error => console.log(error));

// app.ports.saveNewCharacter.subscribe(async json => {
//   await addCharacter(json, storage, db, fireBase.getTimestamp(), userData.uid);
//   app.ports.createdCharacter.send(true);
// });
