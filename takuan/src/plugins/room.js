var Takuyuan = Takuyuan || { plugins: {} }; // varではなくletだとエラー

Takuyuan.plugins.room = {
  init: (target) => {
    $(target).append('<a>test</a>')
  }
}