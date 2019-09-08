
import { Getters, Mutations, Actions } from '../types';
import {
  State, IGetters, IMutations, IActions,
} from './types';


// 状態管理用state
const todoState: State = ({ todos: [] } as State);

// 値の取得
const getters: Getters<State, IGetters> = {
  todos: state => state.todos,
  todosCount: state => state.todos.length,
};

// Vuexのストアの状態を変更できる唯一の方法
const mutations: Mutations<State, IMutations> = {
  addTodoText(state, text) {
    const todo = {
      id: 0,
      text,
      completed: false,
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
    commit('addTodoText', text);
  },
};

export default {
  namespaced: true,
  state: todoState,
  mutations,
  getters,
  actions,
};
