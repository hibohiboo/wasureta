
<template>
  <span v-if="active">
    <slot></slot>
  </span>
  <a href="#" v-on:click="onClick" v-else>
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

  get active() {
    return this.$store.getters["todo/visibilityFilter"] === this.filter;
  }

  onClick() {
    this.$store.dispatch("todo/setVisibilityFilter", this.filter);
  }
}
</script>
