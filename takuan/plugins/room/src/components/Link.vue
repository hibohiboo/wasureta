
<template>
  <a href="#">
    <slot></slot>
  </a>
</template>
<script lang="ts">
import { Prop, Component, Vue } from "vue-property-decorator";
@Component
export default class Link extends Vue {}
</script>
