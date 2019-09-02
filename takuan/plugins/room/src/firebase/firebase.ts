import * as firebase from 'firebase';

const firebaseOptions = require('./firebaseOptions');

firebase.initializeApp(firebaseOptions);
export const lobbyRef = firebase
  .firestore()
  .collection('chattools')
  .doc('lobby')
  .collection('rooms')
  .doc('Lobby')
  .collection('messages');
export const serverTimestamp = firebase.firestore.FieldValue.serverTimestamp();
