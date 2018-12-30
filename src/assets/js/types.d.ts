// コンパイルを通すため、外部から読み込むjsライブラリの宣言を行う。
declare module 'firebase';
declare module 'firebaseui';
declare module 'firebase';
declare module 'vue';

// JQueryのインタフェースの拡張を行う
interface JQuery {
  sidenav(): JQuery;
}
