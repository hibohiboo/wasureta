import Vue from 'vue';
import App from './App.vue';
import { lobbyRef, serverTimestamp } from './firebase/firebase';

Vue.config.productionTip = false;

// new Vue({
//   render: h => h(App),
// }).$mount('#app');
// lobbyRef.orderBy('createdAt', 'desc').limit(20).onSnapshot((qs: firebase.firestore.QuerySnapshot) => {
//   qs.docChanges().reverse().forEach((change: firebase.firestore.DocumentChange) => {
//     if (`${change.type}` !== 'added') {
//       return;
//     }
//     const data = change.doc.data();
//     console.log(data);

//     // serverTimestampは、サーバに追加されたときに値が決まるので、
//     // add した直後にはsecondsの項目が設定されていない。
//     const createdAt = data.createdAt && data.createdAt.seconds ? data.createdAt.seconds * 1000 : data.common.createdAt;
//     // app.ports.addChat.send({
//     //   name: data.common.name,
//     //   text: data.common.text,
//     //   createdAt: moment(createdAt).format("YYYY-MM-DD HH:mm:ss")//.toISOString()
//     // });
//   });
// });
window.addEventListener('init-plugin-room', (e: CustomEvent<IPluginEvent>) => {

  new Vue({
    render: h => h(App),
  }).$mount('#app');
  e.detail.firebase.orderBy('createdAt', 'desc').limit(20).onSnapshot((qs: firebase.firestore.QuerySnapshot) => {
    qs.docChanges().reverse().forEach((change: firebase.firestore.DocumentChange) => {
      if (`${change.type}` !== 'added') {
        return;
      }
      const data = change.doc.data();
      console.log(data);

      // serverTimestampは、サーバに追加されたときに値が決まるので、
      // add した直後にはsecondsの項目が設定されていない。
      const createdAt = data.createdAt && data.createdAt.seconds ? data.createdAt.seconds * 1000 : data.common.createdAt;
      // app.ports.addChat.send({
      //   name: data.common.name,
      //   text: data.common.text,
      //   createdAt: moment(createdAt).format("YYYY-MM-DD HH:mm:ss")//.toISOString()
      // });
    });
  });
});

interface IPluginEvent {
  firebase: firebase.firestore.CollectionReference
}
const pluginLoadEvent: CustomEvent<IPluginEvent> = new CustomEvent('init-plugin-room', {
  detail: {
    firebase: lobbyRef,
  },
});
window.dispatchEvent(pluginLoadEvent);
