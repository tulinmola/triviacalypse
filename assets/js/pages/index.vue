<template>
  <router-view></router-view>
</template>

<script lang="coffee">
import VueRouter from "vue-router"
import routes from "./routes"
export default
  el: "#app"
  router: new VueRouter({routes})
</script>
