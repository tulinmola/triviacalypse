<template>
  <footer v-if="players.length" class="answers">
    {{ usernames }}
  </footer>
</template>

<script lang="coffee">
import storage from "../storage"
import _ from "lodash"

export default
  data: ->
    players: []

  computed:
    currentUser: ->
      storage.getCurrentUser()

    usernames: ->
      if @players.length > 1
        firsts = @players
          .slice(0, -1)
          .map(@getUsername)
          .join(", ")
        [last] = @players.slice(-1)
        "#{firsts} and #{@getUsername(last)} answered."
      else
        [player] = @players
        "#{@getUsername(player)} answered."

  methods:
    reset: ->
      @players = []

    push: (player) ->
      @players.push(player) unless _.find(@players, "username", player.username)

    getUsername: (player) ->
      if player.id == @currentUser.id then "You" else player.username
</script>

<style lang="scss">
.answers{
  font-size: 11px;
  line-height: 20px;
  padding: $padding;
  transition: height $transition-time;
}
</style>
