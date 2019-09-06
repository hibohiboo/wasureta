
import { TodoItem } from '../models/TodoItem';

export interface State {
  todos: TodoItem[];
}

// getters向け、getter関数の戻り型を定義
export interface IGetters {
  // 関数名:戻り型
  todos: TodoItem[];
  todosCount: number;
}

export const ADD_TODO_TEXT = 'ADD_TODO_TEXT';
export const DONE_TODO_TEXT = 'DONE_TODO_TEXT';

// mutations向け、mutation関数のpayloadを定義
export interface IMutations {
  // 関数名:payloadの型
  [ADD_TODO_TEXT]: string;
}

// actions向け、action関数のpayloadを定義
export interface IActions {
  // 関数名:payloadの型
  asyncSetTodoText: string;
}
