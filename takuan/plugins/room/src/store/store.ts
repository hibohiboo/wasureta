import Vue from 'vue';
import Vuex from 'vuex';
import { Immutable } from 'babel-types';

Vue.use(Vuex);
export type Todo = {
  id: number;
  text: string;
}
export interface State {
  todos: Todo[];
}
// 状態管理用state
export const state: State = ({ todos: [] } as State);

// getter関数の定義でプログラマが自由に決めることができるのは「関数名」と「戻り型」のみ。
interface IGetters {
  // 関数名:戻り型
  todos: Todo[];
}

// getter関数の引数は固定のため、インデックスシグネチャを利用して全てのgetter関数にState型とgetter関数の型参照を定義
type Getters<S, G, RS = {}, RG = {}> = {
  // [K in keyof G]: 定義されている関数名を取得
  // G[K] ： 取得した戻り型を付与
  // RS,RG : 第三引数、第四引数については保留
  [K in keyof G]: (state: S, getters: G, rootState: RS, rootGetters: RG) => G[K]
}

// 値の取得
export const getters: Getters<State, IGetters> = {
  todos: () => state.todos,
};



// 状態の変化
export const ADD_TODO_TEXT = "ADD_TODO_TEXT";

// mutation関数の戻り値はvoidで固定。自由に決めることができるのは「関数名」と「payload」
interface IMutations {
  // 関数名:payloadの型
  [ADD_TODO_TEXT]: string;
}
type Mutations<S, M> = {
  [K in keyof M]: (state: S, payload: M[K]) => void
}

export const mutations: Mutations<State, IMutations> = {
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

// Actionはgetters・mutations・同じModuleの参照・Rootの参照を第一引数のcontextに持っている
interface IActions {
  // 関数名:payloadの型
  asyncSetTodoText: string;
}
// Actionsの戻り値は保留
type Actions<S, A> = {
  // Contextはいったんunknown
  [K in keyof A]: (ctx: unknown, payload: A[K]) => any
}
export const actions = {
  addTodoText({ commit }, text) {
    commit(ADD_TODO_TEXT, text);
  },
};

export default new Vuex.Store({
  state,
  mutations,
  getters,
  actions,
});