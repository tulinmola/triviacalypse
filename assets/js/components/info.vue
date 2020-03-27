<template>
  <t-overlay>
    <h2 slot="header">Triviacalypse</h2>

    <template slot="body">
      <p>
        This game is made with <i class="fas fa-heart"></i> by
        <a href="https://twitter.com/tulinmola" target="_blank">@tulinmola</a>
        for the enjoyment of your hearts during this confinement.
      </p>

      <p>
        If you have a curious mind the source code is available at
        <a href="https://github.com/tulinmola/triviacalypse">
          <i class="fab fa-github"></i> GitHub
        </a>. It is developed using
        <a href="https://elixir-lang.org/" target="_blank">Elixir</a>,
        <a href="https://www.phoenixframework.org/" target="_blank">
          <i class="fab fa-phoenix-framework"></i> Phoenix
        </a> and
        <a href="https://vuejs.org/" target="_blank">
          <i class="fab fa-vuejs"></i> Vue.js
        </a>.
        Questions are extracted from the amazing 
        <a href="https://opentdb.com/" target="_blank">Open Trivia DB</a>
        project.
      </p>

      <p>
        Thank you very much for playing!
      </p>

      <a @click.prevent="$emit('close')" href="#" class="overlay-button">
        Back to game!
      </a>
    </template>
  </t-overlay>
</template>

<script lang="coffee">
export default {}
</script>
