<template>
  <div class="game">
    <h2>Game</h2>

    <ul v-if="players" class="players">
      <li v-for="player in players" :key="player.id">
        <dl><dt>{{player.id}} {{ player.username }}</dt><dd>{{ player.score }}</dd></dl>
      </li>
    </ul>
    <p v-else>Loading players…</p>
  </div>
</template>

<script lang="coffee">
import socket from "../socket"
import storage from "../storage"
import _ from "lodash"

export default
  data: ->
    channel: null
    players: null

  mounted: ->
    @$nextTick => @join()

  beforeDestroy: ->
    @channel.leave()

  computed:
    id: ->
      @$route.params.id

    currentUser: ->
      storage.getCurrentUser()

  methods:
    join: ->
      payload =
        user_id: @currentUser.id
        username: @currentUser.username

      @channel = socket.channel("game:#{@id}", payload)

      @channel.join()
        .receive("ok", @onJoin)
        .receive("error", @onChannelError)

      @channel.on("add_player", @addPlayer)
      @channel.on("update_player", @updatePlayer)

    onJoin: (response) ->
      {@players} = response

    onChannelError: (response) ->
      console.error "error", response

    addPlayer: (player) ->
      @players.push(player) unless _.find(@players, id: player.id)

    updatePlayer: (player) ->
      current = _.find(@players, id: player.id)
      _.extend(current, player) if current?
</script>

<style lang="scss">
h2 {
  color: #666;
}
</style>
