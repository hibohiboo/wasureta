<template>
  <div id="app">
    <AddTodo />
    <TodoList :todos="todos" />
  </div>
</template>

<script lang="ts">
import { Component, Vue } from "vue-property-decorator";
import TodoList from "./components/TodoList.vue";
import AddTodo from "./components/AddTodo.vue";

@Component({
  components: {
    TodoList,
    AddTodo
  }
})
export default class App extends Vue {
  get todos() {
    return this.$store.getters.todos;
  }
}
</script>

<style>
#app {
  text-align: center;
  margin-top: 60px;
}
</style>
