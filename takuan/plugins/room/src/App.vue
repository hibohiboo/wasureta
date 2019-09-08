<template>
  <div id="app">
    <AddTodo />
    <TodoList :todos="todos" />
    <Footer />
  </div>
</template>

<script lang="ts">
import { Component, Vue } from "vue-property-decorator";
import * as Vuex from "vuex";
import TodoList from "./components/TodoList.vue";
import AddTodo from "./components/AddTodo.vue";
import Footer from "./components/Footer.vue";

@Component({
  components: {
    TodoList,
    AddTodo,
    Footer
  }
})
export default class App extends Vue {
  $store!: Vuex.ExStore;

  get todos() {
    return this.$store.getters["todo/todos"];
  }
}
</script>

<style>
#app {
  text-align: center;
  margin-top: 60px;
}
</style>
