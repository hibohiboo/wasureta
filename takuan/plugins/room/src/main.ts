import Vue from 'vue';
import App from './App.vue';
import store from './store';

store.dispatch('todo/addTodo', 'Hello World!');
store.dispatch('todo/addTodo', 'Hello World!!');
store.dispatch('todo/toggleTodo', 0);

console.log('todos', store.getters.todos);
console.log('count', store.getters.todosCount);
new Vue({
  render: (h: (app: any) => Vue.VNode) => h(App),
  store,
}).$mount('#app');
