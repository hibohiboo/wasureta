
<template>
  <ul class="todos">
    <Todo v-for="todo in todos" :key="todo.id" :todo="todo" />
  </ul>
</template>
<script lang="ts">
import { Prop, Component, Vue, Emit } from "vue-property-decorator";
import Todo from "./Todo.vue";
import { TodoItem } from "../models/TodoItem";

@Component({ components: { Todo } })
export default class TodoList extends Vue {
  @Prop()
  public todos: TodoItem[];
}
</script>