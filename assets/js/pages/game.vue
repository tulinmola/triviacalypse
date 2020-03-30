<template>
  <div>
    <template v-if="question">
      <question v-if="question" ref="question" :question="question" class="container" @answer="setAnswer"/>

      <answers ref="answers"/>
    </template>

    <header v-else>
      <div class="container">
        <template v-if="isWaiting">
          <h1>New Game</h1>
          <span class="header-subtitle">
            <template v-if="isOwner">Waiting for players</template>
            <template v-else>Waiting for creator to start</template>
          </span>
        </template>
        <template v-else>
          <h1>Game Finished</h1>
          <span class="header-subtitle">
            <template v-if="won">You won!</template>
            <template v-else>Check your score!</template>
          </span>
        </template>

        <router-link :to="{name: 'home'}" class="header-icon header-icon-left">
          <i class="fas fa-chevron-circle-left"></i>
        </router-link>
      </div>
    </header>

    <main class="container">
      <t-connection-error v-if="retrying"/>

      <template v-if="isWaiting && isOwner">
        <h2>Duration</h2>
        <form>
          <div class="select">
            <i class="fas fa-caret-down"></i>
            <select v-model="type">
              <option value="small">Small</option>
              <option value="medium">Medium</option>
              <option value="large">Large</option>
            </select>
          </div>
        </form>
      </template>

      <h2>Players</h2>
      <players :players="players"/>
    </main>

    <t-buttons v-if="isWaiting">
      <t-button @action="share">Invite Friends</t-button>
      <template v-if="isOwner">
        <t-button @action="start" :type="isNotAlone? 'primary': 'secondary'">Start Game</t-button>
        <t-button @action="destroy" type="secondary danger">Delete Game</t-button>
      </template>
    </t-buttons>

    <t-overlay v-if="notFound">
      <h2 slot="header">Game not found</h2>
  
      <template slot="body">
        <p>
          Ops! We didn't find the game you were looking for. Maybe
          it was deleted or simply ended, and now it doesn't exist
          anymore…
        </p>

        <router-link :to="{name: 'home'}" class="overlay-button">
          Go to game list
        </router-link>
      </template>
    </t-overlay>
  </div>
</template>

<script lang="coffee">
import socket from "../socket"
import storage from "../storage"
import share from "../share"
import api from "../api"
import _ from "lodash"

import Players from "../components/players"
import Question from "../components/question"
import Answers from "../components/answers"

export default
  data: ->
    game: null
    channel: null
    type: "medium"
    question: null
    notFound: false
    retrying: false

  mounted: ->
    @$nextTick => @join()

  beforeDestroy: ->
    @channel.leave()

  watch:
    question: ->
      @$refs.answers?.reset()

  computed:
    id: ->
      @$route.params.id

    isWaiting: ->
      @game?.status == "waiting"

    isPlaying: ->
      @game?.status == "playing"

    isFinished: ->
      @game?.status == "finished"

    players: ->
      @game?.players

    creatorId: ->
      @game?.creator_id

    currentUser: ->
      storage.getCurrentUser()

    isNotAlone: ->
      @players?.length > 1

    isOwner: ->
      @currentUser.id == @creatorId

    won: ->
      winner = _.maxBy(@players, "score")
      winner?.id == @currentUser.id

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
      @channel.on("answered", @onAnswered)
      @channel.on("correct_answer", @onCorrectAnswer)
      @channel.on("delete", @onDelete)
      @channel.on("finish", @onFinish)

    onJoin: ({@game, @question}) ->
      @retrying = false

    onChannelError: (response) ->
      switch response.reason
        when "not_found"
          @notFound = true
          @channel.leave()
        else
          @retrying = true

    findPlayer: (id) ->
      _.find(@players, id: id)

    onPlayer: (player) ->
      current = @findPlayer(player.id)
      if current?
        _.extend(current, player)
      else
        @players.unshift(player)

    onQuestion: (@question) ->
      @game.status = "playing"

    onAnswered: ({id}) ->
      player = @findPlayer(id)
      @$refs.answers?.push(player)

    onCorrectAnswer: ({value, counts}) ->
      @$refs.question?.setCorrectAnswer(value, counts)

    onDelete: ->
      @notFound = true

    onFinish: ->
      @game.status = "finished"
      @question = null

    share: ->
      share.url(window.location.href)

    start: ->
      api.startGame(@game, {@type})

    destroy: ->
      @channel.leave()
      api.deleteGame(@game).then =>
        @$router.replace({name: 'home'})

    setAnswer: (value) ->
      @currentAnswer = value
      @channel.push("answer", {value})

  components:
    "players": Players
    "question": Question
    "answers": Answers
</script>
