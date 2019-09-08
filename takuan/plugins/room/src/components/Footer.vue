
<template>
  <p>
    Show:
    <Link>All</Link>,
    <Link>Active</Link>,
    <Link>Completed</Link>
  </p>
</template>
<script lang="ts">
import { Prop, Component, Vue } from "vue-property-decorator";
import Link from "./Link.vue";
@Component({ components: { Link } })
export default class Footer extends Vue {}
</script>
