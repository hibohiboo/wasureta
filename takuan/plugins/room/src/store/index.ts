import Vue from 'vue';
import Vuex from 'vuex';
import todo from './todo';
// ルートコンポーネントに store オプションを指定することですべての子コンポーネントにストアを注入。
Vue.use(Vuex);

export default new Vuex.Store({
  modules: { todo },
});
