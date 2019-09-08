
import { TodoItem } from '../../models/TodoItem';

export type VisibilityFilter = 'SHOW_ALL' | 'SHOW_COMPLETED' | 'SHOW_ACTIVE';
export interface State {
  todos: TodoItem[];
  // String Lieral Typesでとりうる値を限定
  visibilityFilter: VisibilityFilter;
}

// getters向け、getter関数の戻り型を定義
export interface IGetters {
  // 関数名:戻り型
  todos: TodoItem[];
  todosCount: number;
  visibilityFilter: VisibilityFilter;
}

export interface RootGetter {
  'todo/todos': IGetters['todos'];
  'todo/todosCount': IGetters['todosCount'];
  'todo/visibilityFilter': IGetters['visibilityFilter'];
}

// mutations向け、mutation関数のpayloadを定義
export interface IMutations {
  // 関数名:payloadの型
  addTodo: string;
  toggleTodo: number;
  setVisibilityFilter: VisibilityFilter;
}

export interface RootMutations {
  // 関数名:payloadの型
  'todo/addTodo': IMutations['addTodo'];
  'todo/toggleTodo': IMutations['toggleTodo'];
  'todo/setVisibilityFilter': IMutations['setVisibilityFilter'];
}

// actions向け、action関数のpayloadを定義
export interface IActions {
  // 関数名:payloadの型
  addTodo: string;
  toggleTodo: number;
  setVisibilityFilter: string;
}

export interface RootActions {
  // 関数名:payloadの型
  'todo/addTodo': IActions['addTodo'];
  'todo/toggleTodo': IActions['toggleTodo'];
  'todo/setVisibilityFilter': IActions['setVisibilityFilter'];
}

// actions
