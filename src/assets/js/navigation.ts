import * as firebase from 'firebase';
import * as $ from 'jquery';
import User from './models/User';
const { Elm } = require('./elm/navigation/Main.elm');

if (!firebase.apps.length) {
  const config = require('./config'); // tslint:disable-line no-var-requires
  firebase.initializeApp(config);
}
const auth = firebase.auth();
auth.onAuthStateChanged((firebaseUser) => {
  let user: User | null = null;
  if (firebaseUser) {
    user = new User(firebaseUser);
    // const twitterId = firebaseUser.providerData
    // .filter(function(userInfo:firebase.UserInfo){return userInfo.providerId === firebase.auth.TwitterAuthProvider.PROVIDER_ID;})
    // .map(function(userInfo:firebase.UserInfo){return userInfo.uid;})[0];
  }
  const mountNode = document.getElementById('navigation');
  const json = JSON.stringify(user);
  const app = Elm.Main.init({ node: mountNode, flags:json });
  // elm -> js
  app.ports.logout.subscribe(() => {
    auth.signOut().then(() => {
      // console.log("Signed out.");
    });
  });
  // elmのdom構築が終わった後にjsのイベントを発火させる
  app.ports.sidenav.subscribe(() => {
    $('.sidenav').sidenav();
  });

});
