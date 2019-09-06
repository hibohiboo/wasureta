<template>
  <li>{{text}}</li>
</template>

<script lang="ts">
import { Component, Prop, Vue } from "vue-property-decorator";
import { TodoItem } from "../models/TodoItem";

@Component
export default class Todo extends Vue {
  @Prop()
  public todo: TodoItem;
  get text() {
    return this.todo.text;
  }
}
</script>
