import Vue from 'vue';
import App from './App.vue';

new Vue({
  render: (h: (app: any) => Vue.VNode) => h(App),
}).$mount('#app');
