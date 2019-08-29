var Takuyuan = Takuyuan || { plugins: {} }; // varではなくletだとエラー

Takuyuan.plugins.room = {
  init: (panel) => {
    const node = panel.open();
    $(node).append(`{{message}}`);
    var vm = new Vue({
      el: node,
      data: {
        message: 'Hello Vue!'
      }
    })
  }
}

