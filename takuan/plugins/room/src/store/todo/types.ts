
import { TodoItem } from '../../models/TodoItem';

export interface State {
  todos: TodoItem[];
}

// getters向け、getter関数の戻り型を定義
export interface IGetters {
  // 関数名:戻り型
  todos: TodoItem[];
  todosCount: number;
}

export interface RootGetter {
  'todo/todos': IGetters['todos'];
  'todo/todosCount': IGetters['todosCount'];
}

// mutations向け、mutation関数のpayloadを定義
export interface IMutations {
  // 関数名:payloadの型
  addTodoText: string;
}

export interface RootMutations {
  // 関数名:payloadの型
  'todo/addTodoText': IMutations['addTodoText'];
}

// actions向け、action関数のpayloadを定義
export interface IActions {
  // 関数名:payloadの型
  asyncSetTodoText: string;
}

export interface RootActions {
  // 関数名:payloadの型
  'todo/asyncSetTodoText': IActions['asyncSetTodoText'];
}

// actions
