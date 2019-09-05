import Vue from 'vue';
import Vuex from 'vuex';

// ルートコンポーネントに store オプションを指定することですべての子コンポーネントにストアを注入。
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
  todosCount: number;
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
  todosCount: () => state.todos.length,
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

// Actionはgetters・mutations・同じModuleの参照・Rootの参照を第一引数のcontextに持っている
interface IActions {
  // 関数名:payloadの型
  asyncSetTodoText: string;
}
// Actionsの戻り値は保留。async functionを指定でき、同期的に書いてもライブラリ中でPromiseとなるため、複雑になる。
type Actions<S, A, G = {}, M = {}, RS = {}, RG = {}> = {
  // Contextはいったんunknown
  [K in keyof A]: (ctx: Context<S, A, G, M, RS, RG>, payload: A[K]) => any
}
type Context<S, A, G, M, RS, RG> = {
  commit: Commit<M>;
  dispatch: Dispatch<A>;
  state: S;
  getters: G;
  rootState: RS;
  rootGetters: RG;
}
// Mで渡ってくるIMutationのkeyofで定義されている関数名を特定する。
// keyof Mは '[ADD_TODO_TEXT]'
// 関数型直前に <T extends keyof M>と付与することでTはkeyof Mで定義されているいずれかしか入力できなくなる
// 第一引数に、これらいずれかの文字列が入力されたとき、第二引数の型がM[T]として確定する。
// Lookup Typesを利用して引数同士の関連付けを行っている。
type Commit<M> = <T extends keyof M>(type: T, payload?: M[T]) => void;
type Dispatch<A> = <T extends keyof A>(type: T, payload?: A[T]) => any;

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