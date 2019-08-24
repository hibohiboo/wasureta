
// import * as M from 'M'; //  tslint-disable-line
import { Elm } from './Main'; //  eslint-disable-line import/no-unresolved
import { lobbyRef, serverTimestamp } from './firebase/firebase';
import moment from 'moment';

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

    // serverTimestampは、サーバに追加されたときに値が決まるので、
    // add した直後にはsecondsの項目が設定されていない。
    const createdAt = data.createdAt && data.createdAt.seconds ? data.createdAt.seconds * 1000 : data.common.createdAt
    app.ports.addChat.send({
      name: data.common.name,
      text: data.common.text,
      createdAt: moment(createdAt).format("YYYY-MM-DD HH:mm:ss")//.toISOString()
    });
  });
});
app.ports.errorToJs.subscribe(error => console.log(error));
app.ports.sendChat.subscribe(chat => {

  lobbyRef.add({
    chattool: "simple"
    , original: chat
    , common: {
      name: chat.name
      , text: chat.text
      , createdAt: chat.createdAt
    }
    , createdAt: serverTimestamp
  });
});