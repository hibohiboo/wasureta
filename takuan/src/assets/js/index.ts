import { loader } from './loader';
require('../css/styles.scss'); // tslint:disable-line no-var-requires

(async () => {
  await loader({ plugins: [{ name: 'room', activate: true }] });
  $('body').removeClass('loading');
  console.log('sppiner off');

  // メニューのトグル機能を設定
  const $nav = $('nav');
  $('#settings').click(() => { $nav.toggleClass('active') });
})();


