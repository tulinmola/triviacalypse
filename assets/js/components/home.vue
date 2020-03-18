<template>
  <div class="home">
    <form @on:submit.prevent>
      <div class="field">
        <label for="usermane">Username</label>
        <input type="text" v-model="username" @change="updateUsername"/>
      </div>
    </form>

    <ul v-if="games" class="games">
      <li v-for="game in games" :key="game.id">
        <router-link :to="{name: 'game', params: {id: game.id}}">
          {{ game.id }} ({{ game.player_count }})
        </router-link>
      </li>
    </ul>
    <p v-else>Loading games…</p>

    <t-buttons>
      <t-button @action="newGame">New Game</t-button>
    </t-buttons>
  </div>
</template>

<script lang="coffee">
import storage from "../storage"
import socket from "../socket"
import api from "../api"
import _ from "lodash"

export default
  data: ->
    username: null
    games: null

  mounted: ->
    @$nextTick =>
      @join()
      @setUsername()

  computed:
    currentUser: ->
      storage.getCurrentUser()

  methods:
    join: ->
      @channel = socket.channel("game:lobby", {})

      @channel.join()
        .receive("ok", @onJoin)
        .receive("error", @onChannelError)

      @channel.on("game", @onGame)

    setUsername: ->
      {@username} = @currentUser

    updateUsername: ->
      updatedUser = _.merge(@currentUser, username: @username)
      storage.setCurrentUser(updatedUser)

    onJoin: (response) ->
      {@games} = response

    onChannelError: (response) ->
      console.error "error", response

    findGame: (id) ->
      _.find(@games, id: id)

    onGame: (game) ->
      current = @findGame(game.id)
      if current?
        _.extend(current, game)
      else
        @games.unshift(game)

    newGame: ->
      params = {}
      api.createGame(params).then (game) =>
        @$router.push(name: "game", params: {id: game.id})
</script>

<style lang="scss">
h2 {
  color: #666;
}
</style>
