
<template>
  <p>
    Show:
    <Link filter="SHOW_ALL">All</Link>,
    <Link filter="SHOW_ACTIVE">Active</Link>,
    <Link filter="SHOW_COMPLETED">Completed</Link>
  </p>
</template>
<script lang="ts">
import { Prop, Component, Vue } from "vue-property-decorator";
import Link from "./Link.vue";
@Component({ components: { Link } })
export default class Footer extends Vue {}
</script>
