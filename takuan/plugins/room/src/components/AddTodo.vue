
<template>
  <div>
    <input type="text" v-model="text" />
    <button @click="addTodo">Add Todo</button>
  </div>
</template>
<script lang="ts">
import { Prop, Component, Vue } from "vue-property-decorator";
import * as Vuex from "vuex";

@Component
export default class AddTodo extends Vue {
  $store!: Vuex.ExStore;

  @Prop({})
  public text: string;

  public addTodo() {
    this.$store.dispatch("todo/addTodo", this.text);
  }
}
</script>
