
import { Getters, Mutations, Actions } from '../types';
import {
  State, IGetters, IMutations, IActions, VisibilityFilter,
} from './types';


// 状態管理用state
const todoState: State = ({ todos: [], visibilityFilter: 'SHOW_ALL' } as State);

// 値の取得
const getters: Getters<State, IGetters> = {
  todos: state => {
    switch (state.visibilityFilter) {
      case 'SHOW_ALL':
        return state.todos;
      case 'SHOW_ACTIVE':
        return state.todos.filter(todo => !todo.completed);
      case 'SHOW_COMPLETED':
        return state.todos.filter(todo => todo.completed);
    }
  },
  todosCount: state => state.todos.length,
  visibilityFilter: state => state.visibilityFilter,
};

// Vuexのストアの状態を変更できる唯一の方法
const mutations: Mutations<State, IMutations> = {
  addTodo(state, text) {
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
  toggleTodo(state, id) {
    const target = state.todos.find(todo => todo.id === id);
    if (target === undefined) {
      throw new Error(`not found id:${id}`);
    }
    target.completed = !target.completed;
  },
  setVisibilityFilter(state, filter) {
    state.visibilityFilter = filter;
  },
};

// ミューテーションをコミットする。非同期処理を含むことができる。
const actions: Actions<
  State,
  IActions,
  IGetters,
  IMutations
> = {
  async addTodo({ commit }, text) {
    commit('addTodo', text);
  },
  async toggleTodo({ commit }, id) {
    commit('toggleTodo', id);
  },
  async setVisibilityFilter({ commit }, filter) {
    switch (filter) {
      case 'SHOW_ALL':
      case 'SHOW_COMPLETED':
      case 'SHOW_ACTIVE':
        commit('setVisibilityFilter', filter);
        return;
      default:
        throw new Error(`cannot set filter:${filter}`);
    }
  },
};

export default {
  namespaced: true,
  state: todoState,
  mutations,
  getters,
  actions,
};
