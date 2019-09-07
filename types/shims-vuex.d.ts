import 'vuex';
import * as Todo from '../takuan/plugins/room/src/store/todo/types';

declare module 'vuex' {
  type Getters<S, G, RS = {}, RG = {}> = {
    [K in keyof G]: (state: S, getters: G, rootState: RS, rootGetters: RG) => G[K]
  }
  type Mutations<S, M> = {
    [K in keyof M]: (state: S, payload: M[K]) => void
  }
  type ExCommit<M> = <T extends keyof M>(type: T, payload?: M[T]) => void;
  type ExDispatch<A> = <T extends keyof A>(type: T, payload?: A[T]) => any;
  type ExActionContext<S, A, G, M, RS, RG> = {
    commit: ExCommit<M>;
    dispatch: ExDispatch<A>;
    state: S;
    getters: G;
    rootState: RS;
    rootGetters: RG;
  }
  type Actions<S, A, G = {}, M = {}, RS = {}, RG = {}> = {
    [K in keyof A]: (ctx: ExActionContext<S, A, G, M, RS, RG>, payload: A[K]) => any
  }
  type RootGetters = Todo.RootGetter; // 増えたら、& Hoge.RootGetter のように、Intersection Typesで連結していく。
  interface ExStore extends Store<{}> {
    // ここに拡張型を追加していく。
    getters: RootGetters
  }

}
