
<template>
  <div>
    <input type="text" v-model="text" />
    <button @click="addTodo">Add Todo</button>
  </div>
</template>
<script lang="ts">
import { Prop, Component, Vue } from "vue-property-decorator";
@Component
export default class AddTodo extends Vue {
  @Prop({})
  public text: string;

  public addTodo() {
    this.$store.dispatch("todo/asyncSetTodoText", this.text);
  }
}
</script>
