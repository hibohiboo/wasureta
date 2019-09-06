import Vue from 'vue';
import App from './App.vue';
import store from './store';

store.dispatch('asyncSetTodoText', 'Hello World!');
store.dispatch('asyncSetTodoText', 'Hello World!!');

console.log('todos', store.getters.todos);
console.log('count', store.getters.todosCount);
new Vue({
  render: (h: (app: any) => Vue.VNode) => h(App),
  store,
}).$mount('#app');
