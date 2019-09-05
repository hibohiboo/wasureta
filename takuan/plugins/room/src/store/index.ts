import Vue from 'vue';
import Vuex from 'vuex';
import { Getters, Mutations, Actions } from './types';
import { State, IGetters, IMutations, IActions, ADD_TODO_TEXT } from './todoType';

// ルートコンポーネントに store オプションを指定することですべての子コンポーネントにストアを注入。
Vue.use(Vuex);

// 状態管理用state
export const state: State = ({ todos: [] } as State);

// 値の取得
export const getters: Getters<State, IGetters> = {
  todos: () => state.todos,
  todosCount: () => state.todos.length,
};

// Vuexのストアの状態を変更できる唯一の方法
export const mutations: Mutations<State, IMutations> = {
  // 定数を関数名として使用できる ES2015 の算出プロパティ名（computed property name）機能を使用
  [ADD_TODO_TEXT](state, text) {
    const todo = {
      id: 0,
      text
    };
    if (state.todos.length !== 0) {
      todo.id = state.todos[state.todos.length - 1].id + 1;
    }
    state.todos.push(todo);
  },
};

// ミューテーションをコミットする。非同期処理を含むことができる。
export const actions: Actions<
  State,
  IActions,
  IGetters,
  IMutations
> = {
  asyncSetTodoText({ commit }, text) {
    commit(ADD_TODO_TEXT, text);
  },
};

export default new Vuex.Store({
  state,
  mutations,
  getters,
  actions,
});