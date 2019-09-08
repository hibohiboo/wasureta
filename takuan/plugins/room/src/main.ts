import Vue from 'vue';
import App from './App.vue';
import store from './store';

store.dispatch('todo/addTodo', 'Hello World!');
store.dispatch('todo/addTodo', 'Hello World!!');
store.dispatch('todo/toggleTodo', 0);

console.log('before', store.getters['todo/visibilityFilter']);
store.dispatch('todo/setVisibilityFilter', 'SHOW_COMPLETED');
console.log('after', store.getters['todo/visibilityFilter']);
console.log('todos', store.getters['todo/todos']);
console.log('count', store.getters['todo/todosCount']);
new Vue({
  render: (h: (app: any) => Vue.VNode) => h(App),
  store,
}).$mount('#app');
