<template>
  <div class="game">
    <h2>Game</h2>

    <ul v-if="players" class="players">
      <li v-for="player in players" :key="player.id">
        <dl><dt>{{player.id}} {{ player.username }}</dt><dd>{{ player.score }}</dd></dl>
      </li>
    </ul>
    <p v-else>Loading players…</p>

    <question v-if="question" :question="question"/>

    <ul class="buttons">
      <li>
        <a href="#" @click.prevent="start" :class="startButtonClass">Start</a>
      </li>
    </ul>
  </div>
</template>

<script lang="coffee">
import socket from "../socket"
import storage from "../storage"
import api from "../api"
import _ from "lodash"
import Question from "./question"

export default
  data: ->
    channel: null
    players: null
    question: null

  mounted: ->
    @$nextTick => @join()

  beforeDestroy: ->
    @channel.leave()

  computed:
    id: ->
      @$route.params.id

    game: ->
      id: @id

    currentUser: ->
      storage.getCurrentUser()

    startButtonClass: ->
      notAlone = @players?.length > 1

      button: true
      "button-primary": notAlone
      "button-secondary": !notAlone

  methods:
    join: ->
      payload =
        user_id: @currentUser.id
        username: @currentUser.username

      @channel = socket.channel("game:#{@id}", payload)

      @channel.join()
        .receive("ok", @onJoin)
        .receive("error", @onChannelError)

      @channel.on("player", @onPlayer)
      @channel.on("question", @onQuestion)

    onJoin: (response) ->
      {@players} = response

    onChannelError: (response) ->
      console.error "error", response

    findPlayer: (id) ->
      _.find(@players, id: id)

    onPlayer: (player) ->
      current = @findPlayer(player.id)
      if current?
        _.extend(current, player)
      else
        @players.unshift(player)

    onQuestion: (@question) ->

    start: ->
      api.startGame(@game)

  components:
    "question": Question
</script>

<style lang="scss">
h2 {
  color: #666;
}
</style>
