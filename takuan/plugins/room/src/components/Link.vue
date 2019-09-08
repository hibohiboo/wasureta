
<template>
  <a href="#" v-on:click="onClick">
    <slot></slot>
  </a>
</template>
<script lang="ts">
import { Prop, Component, Vue } from "vue-property-decorator";
import { VisibilityFilter } from "../store/todo/types";
import * as Vuex from "vuex";

@Component
export default class Link extends Vue {
  $store!: Vuex.ExStore;

  @Prop()
  public filter: VisibilityFilter;

  onClick() {
    this.$store.dispatch("todo/setVisibilityFilter", this.filter);
  }
}
</script>
