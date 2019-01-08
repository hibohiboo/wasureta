import * as firebase from 'firebase';
import * as firebaseui from 'firebaseui';

const config = require('./_config'); // tslint:disable-line no-var-requires
firebase.initializeApp(config);

const uiConfig = {
  signInSuccessUrl: '/',
  signInOptions: [
    firebase.auth.TwitterAuthProvider.PROVIDER_ID,
  ],
  callbacks: {
    signInSuccessWithAuthResult(authResult, redirectUrl) {
      // User successfully signed in.
      return true;
    },
    uiShown() {
      // The widget is rendered. Hide the loader.
      const elm = document.getElementById('loader');
      if (!elm) {
        return;
      }
      elm.style.display = 'none';
    },
  },
  // 利用規約。こことプライバシーポリシーのURLをhttps:// からのURLに変えると動かなくなることがある
  tosUrl: '/agreement.html',
  // プライバシーポリシー
  privacyPolicyUrl() {
    window.location.assign('/privacy-policy.html');
  },
};

// Initialize the FirebaseUI Widget using Firebase.
const ui = new firebaseui.auth.AuthUI(firebase.auth());
// The start method will wait until the DOM is loaded.
ui.start('#firebaseui-auth-container', uiConfig);
console.log(ui);
