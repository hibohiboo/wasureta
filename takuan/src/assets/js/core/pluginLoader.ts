interface Plugin {
  name: string;      // 
  activate: boolean; // プラグインが有効かどうか
  dependencies: string[]; // 依存ファイル
  pluginRootId: string; // プラグインを描画する要素のid
}
interface Options {
  plugins: Plugin[]
}
import window from './window';

export const pluginLoader = (options: Options, panel) => {
  return new Promise((resolve, reject) => {
    // プラグインを読み込む
    const startTime = performance.now(); // 開始時間
    console.log('読込開始', options.plugins);

    // プラグインの描画先となる要素の作成
    const $content = $('#main-content');
    options.plugins.forEach(plugin => {
      $content.append($('<div>').attr('id', plugin.pluginRootId));
    });


    // ファイルを追加で読み込む
    $.ajaxSetup({
      cache: true
    });
    const plugins = options.plugins.filter(plugin => plugin.activate).map(plugin => plugin.name);
    const pluginUrls = plugins.map(name => `/plugins/${name}/index.js`);
    const dependencies = options.plugins.map(plugin => plugin.dependencies.map(name => `${plugin.name}/${name}`)).reduce((acc, val) => acc.concat(val), []);
    const dependenciesUrl = dependencies.map(name => `/plugins/${name}`);
    const urls = dependenciesUrl.concat(pluginUrls);

    // 有効なプラグインをすべて読み込む
    $.when(...urls.map(url => $.getScript(url)))
      .done(function (script, textStatus) {
        const endTime = performance.now(); // 終了時間
        console.log('読み込み終了', endTime - startTime);
        resolve();
      })
      .fail(function (jqxhr, settings, exception) {
        console.log(jqxhr);
        console.log(settings);
        console.log(exception);
        reject();
      });
  })

}