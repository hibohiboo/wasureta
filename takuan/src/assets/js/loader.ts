interface Plugin {
  name: string;
  activate: boolean;
}
interface Options {
  plugins: Plugin[]
}

export const loader = (options: Options) => {
  return new Promise((resolve, reject) => {
    $.ajaxSetup({
      cache: true
    });
    const plugins = options.plugins.filter(plugin => plugin.activate).map(plugin => plugin.name);

    // プラグインを読み込む
    const startTime = performance.now(); // 開始時間
    console.log('読込開始', plugins);
    $.when(...plugins.map(name => $.getScript(`/plugins/${name}.js`)))
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