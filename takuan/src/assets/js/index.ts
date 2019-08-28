import { loader } from './loader';
require('../css/styles.scss'); // tslint:disable-line no-var-requires


const $nav = $('nav');
$('#settings').click(() => { $nav.toggleClass('active') });

(async () => {
  await loader({ plugins: [{ name: 'room', activate: true }] });
  $('body').removeClass('loading');
  console.log('sppiner off');
})();


