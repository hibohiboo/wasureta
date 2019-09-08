<template>
  <li v-bind:style="{ textDecoration: textDecoration }" v-on:click="onClick">{{text}}</li>
</template>

<script lang="ts">
import * as Vuex from 'vuex';
import { Component, Prop, Vue } from 'vue-property-decorator';
import { TodoItem } from '../models/TodoItem';

@Component
export default class Todo extends Vue {
  $store!: Vuex.ExStore;

  @Prop()
  public todo: TodoItem;

  get text() {
    return this.todo.text;
  }

  get textDecoration() {
    return this.todo.completed ? 'line-through' : 'none';
  }

  onClick() {
    this.$store.dispatch('todo/toggleTodo', this.todo.id);
  }
}
</script>
