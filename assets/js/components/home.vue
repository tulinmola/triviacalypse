<template>
  <div class="home">
    <ul class="buttons">
      <li>
        <a href="#" @click.prevent="newGame" class="button button-primary">New Game</a>
      </li>
    </ul>
  </div>
</template>

<script lang="coffee">
import uuid from "../uuid"

export default
  data: ->
    title: "home"

  methods:
    newGame: ->
      @$router.push(name: "game", params: {id: uuid()})
</script>

<style lang="scss">
h2 {
  color: #666;
}
</style>
