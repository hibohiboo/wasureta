// getter関数の引数は固定のため、インデックスシグネチャを利用して全てのgetter関数にState型とgetter関数の型参照を定義
type Getters<S, G, RS = {}, RG = {}> = {
  // [K in keyof G]: 定義されている関数名を取得
  // G[K] ： 取得した戻り型を付与
  // RS,RG : 第三引数、第四引数については保留
  [K in keyof G]: (state: S, getters: G, rootState: RS, rootGetters: RG) => G[K]
}

type Mutations<S, M> = {
  [K in keyof M]: (state: S, payload: M[K]) => void
}

// Mで渡ってくるIMutationのkeyofで定義されている関数名を特定する。
// keyof Mは '[ADD_TODO_TEXT]'
// 関数型直前に <T extends keyof M>と付与することでTはkeyof Mで定義されているいずれかしか入力できなくなる
// 第一引数に、これらいずれかの文字列が入力されたとき、第二引数の型がM[T]として確定する。
// Lookup Typesを利用して引数同士の関連付けを行っている。
type Commit<M> = <T extends keyof M>(type: T, payload?: M[T]) => void;
type Dispatch<A> = <T extends keyof A>(type: T, payload?: A[T]) => any;
type Context<S, A, G, M, RS, RG> = {
  commit: Commit<M>;
  dispatch: Dispatch<A>;
  state: S;
  getters: G;
  rootState: RS;
  rootGetters: RG;
}
// Actionはgetters・mutations・同じModuleの参照・Rootの参照を第一引数のcontextに持っている
// Actionsの戻り値は保留としてany。async functionを指定でき、同期的に書いてもライブラリ中でPromiseとなるため、複雑になる。
type Actions<S, A, G = {}, M = {}, RS = {}, RG = {}> = {
  [K in keyof A]: (ctx: Context<S, A, G, M, RS, RG>, payload: A[K]) => any
}

export { Getters, Mutations, Actions };