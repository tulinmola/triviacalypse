<template>
  <li>
    <a :class="`button button-${type}`" href="#" @click.prevent="$emit('action')">
      <slot></slot>
    </a>
  </li>
</template>

<script lang="coffee">
export default
  props:
    type: default: "primary"
</script>

<style>
.button {
  background-color: #ff0;
}
</style>
