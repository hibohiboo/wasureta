interface Plugin {
  name: string;
  activate: boolean;
}
interface Options {
  plugins: Plugin[]
}

export const loader = (options: Options) => {
  return new Promise((resolve, reject) => {
    // プラグインを読み込む
    const startTime = performance.now(); // 開始時間
    console.log('読込開始', options.plugins);
    $.ajaxSetup({
      cache: true
    });
    const plugins = options.plugins.filter(plugin => plugin.activate).map(plugin => plugin.name);
    const pluginUrls = plugins.map(name => `/plugins/${name}/index.js`);

    $.when(...pluginUrls.map(url => $.getScript(url)))
      .done(function (script, textStatus) {
        plugins.forEach(name => {
          Takuyuan.plugins[name].init(document.getElementById('main-content'));
        });
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