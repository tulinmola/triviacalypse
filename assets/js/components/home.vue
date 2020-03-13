<template>
  <div class="home">
    <h2>{{ title }}</h2>
  </div>
</template>

<script lang="coffee">
export default
  data: ->
    title: "home"
</script>

<style lang="scss">
h2 {
  color: #666;
}
</style>
