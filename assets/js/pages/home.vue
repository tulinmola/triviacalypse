<template>
  <div>
    <header>
      <h1>Triviacalypse</h1>
      <span class="header-subtitle">Covid-19 Edition</span>
    </header>

    <main class="container">
      <h2>Username</h2>

      <form @on:submit.prevent>
        <input type="text" v-model="username" @change="updateUsername"/>
      </form>

      <h2>Games</h2>
      <games :games="games"/>
    </main>

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

import Games from "../components/games"

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

  components:
    "games": Games
</script>
