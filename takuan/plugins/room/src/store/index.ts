import Vue from 'vue';
import Vuex from 'vuex';
import { Getters, Mutations, Actions } from './types';
import {
  State, IGetters, IMutations, IActions, ADD_TODO_TEXT,
} from './todoType';

// ルートコンポーネントに store オプションを指定することですべての子コンポーネントにストアを注入。
Vue.use(Vuex);

// 状態管理用state
const todoState: State = ({ todos: [] } as State);

// 値の取得
const getters: Getters<State, IGetters> = {
  todos: (state) => state.todos,
  todosCount: (state) => state.todos.length,
};

// Vuexのストアの状態を変更できる唯一の方法
const mutations: Mutations<State, IMutations> = {
  // 定数を関数名として使用できる ES2015 の算出プロパティ名（computed property name）機能を使用
  [ADD_TODO_TEXT](state, text) {
    const todo = {
      id: 0,
      text,
    };
    if (state.todos.length !== 0) {
      todo.id = state.todos[state.todos.length - 1].id + 1;
    }
    state.todos.push(todo);
  },
};

// ミューテーションをコミットする。非同期処理を含むことができる。
const actions: Actions<
  State,
  IActions,
  IGetters,
  IMutations
> = {
  asyncSetTodoText({ commit }, text) {
    commit(ADD_TODO_TEXT, text);
  },
};

const todoModule = {
  namespaced: true,
  state: todoState,
  mutations,
  getters,
  actions,
}

export default new Vuex.Store({
  modules: { todo: todoModule }
});
