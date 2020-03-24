<template>
  <div>
    <header>
      <div class="container">
        <h1>Triviacalypse</h1>
        <span class="header-subtitle">Covid-19 Edition</span>

        <a @click.prevent="showInfo=true" href="#" class="header-icon header-icon-right">
          <i class="fas fa-info-circle"></i>
        </a>
      </div>
    </header>

    <main class="container">
      <h2>Username</h2>

      <form @on:submit.prevent>
        <input type="text" v-model="username" @change="updateUsername"/>
      </form>

      <h2>New games</h2>
      <games :games="pendingGames"/>

      <template v-if="startedGames.length">
        <h2>Already started games</h2>
        <games :games="startedGames"/>
      </template>

      <template v-if="finishedGames.length">
        <h2>Finished games</h2>
        <games :games="finishedGames"/>
      </template>
    </main>

    <t-buttons>
      <t-button @action="newGame">New Game</t-button>
    </t-buttons>

    <info v-if="showInfo" @close="showInfo = false"/>
  </div>
</template>

<script lang="coffee">
import storage from "../storage"
import socket from "../socket"
import api from "../api"
import _ from "lodash"

import Games from "../components/games"
import Info from "../components/info"

export default
  data: ->
    username: null
    games: null
    showInfo: false

  mounted: ->
    @$nextTick =>
      @join()
      @setUsername()

  computed:
    currentUser: ->
      storage.getCurrentUser()

    pendingGames: ->
      @filterGames("waiting")

    startedGames: ->
      @filterGames("playing")

    finishedGames: ->
      @filterGames("finished")

  methods:
    join: ->
      @channel = socket.channel("game:lobby", {})

      @channel.join()
        .receive("ok", @onJoin)
        .receive("error", @onChannelError)

      @channel.on("game", @onGame)
      @channel.on("delete", @onDelete)

    setUsername: ->
      {@username} = @currentUser

    updateUsername: ->
      updatedUser = _.merge(@currentUser, username: @username)
      storage.setCurrentUser(updatedUser)

    onJoin: (response) ->
      {@games} = response

    onChannelError: (response) ->
      console.error "error", response

    filterGames: (status) ->
      _.filter(@games, {status: status})

    findGame: (id) ->
      _.find(@games, id: id)

    onGame: (game) ->
      current = @findGame(game.id)
      if current?
        _.extend(current, game)
      else
        @games.unshift(game)

    onDelete: (game) ->
      index = _.findIndex(@games, {id: game.id})
      @games.splice(index, 1) if index >= 0

    newGame: ->
      params = {}
      api.createGame(params).then (game) =>
        @$router.push(name: "game", params: {id: game.id})

  components:
    "games": Games
    "info": Info
</script>
