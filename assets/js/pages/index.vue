<template>
  <main>
    <header>
      <h1>Triviacalypse</h1>
      <span class="header-subtitle">Covid-19 Edition</span>
    </header>

    <router-view></router-view>
  </main>
</template>

<script lang="coffee">
import VueRouter from "vue-router"
import routes from "./routes"
export default
  el: "#app"
  router: new VueRouter({routes})
</script>

<style lang="scss">
main {
  max-width: 720px;
  margin: auto;
}
</style>
