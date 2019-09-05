export type Todo = {
  id: number;
  text: string;
}

export interface State {
  todos: Todo[];
}

// getters向け、getter関数の戻り型を定義
export interface IGetters {
  // 関数名:戻り型
  todos: Todo[];
  todosCount: number;
}

export const ADD_TODO_TEXT = "ADD_TODO_TEXT";

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
