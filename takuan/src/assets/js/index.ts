import { pluginLoader } from './core/pluginLoader';
import { PanelService } from './core/PanelService';
require('../css/styles.scss'); // tslint:disable-line no-var-requires

(async () => {
  await pluginLoader({ plugins: [{ name: 'room', activate: true, dependencies: ['chunk-vendors.js'], pluginRootId: 'app' }] }, new PanelService());
  $('body').removeClass('loading');
  console.log('sppiner off');

  // メニューのトグル機能を設定
  const $nav = $('nav');
  $('#settings').click(() => { $nav.toggleClass('active') });
})();
