
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
  addTodo: string;
  toggleTodo: number;
}

export interface RootMutations {
  // 関数名:payloadの型
  'todo/addTodo': IMutations['addTodo'];
  'todo/toggleTodo': IMutations['toggleTodo'];
}

// actions向け、action関数のpayloadを定義
export interface IActions {
  // 関数名:payloadの型
  addTodo: string;
  toggleTodo: number;
}

export interface RootActions {
  // 関数名:payloadの型
  'todo/addTodo': IActions['addTodo'];
  'todo/toggleTodo': IActions['toggleTodo'];

}

// actions
