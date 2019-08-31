
declare var Vue; // VueはCDNから読み込み

var Takuyuan = Takuyuan || { plugins: {} }; // varではなくletだとエラー

Takuyuan.plugins.room = {
  init: (panel) => {
    const node = panel.open();
    const app = document.createElement('div');
    app.innerText = `{{message}}`
    node.appendChild(app);
    var vm = new Vue({
      el: node,
      data: {
        message: 'Hello Vue!'
      }
    })
  }
}

// デバッグ用
Takuyuan.plugins.room.init({ open: () => document.getElementById('app') });