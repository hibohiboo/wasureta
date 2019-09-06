<template>
  <div id="app">
    <TodoList :todos="todos" />
  </div>
</template>

<script lang="ts">
import { Component, Vue } from "vue-property-decorator";
import TodoList from "./components/TodoList.vue";

@Component({
  components: {
    TodoList
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
