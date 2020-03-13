<template>
  <div class="game">
    <h2>Game</h2>
    <form @on:submit.prevent>
      <div class="field">
        <label for="usermane">Username</label>
        <input type="text" v-model="username" @change="updateUsername"/>
      </div>
    </form>
    <ul class="users">
      <li v-for="user in users" :key="user.id">
        {{ user.username }} ({{ user.count }})
      </li>
    </ul>
  </div>
</template>

<script lang="coffee">
import {Presence} from "phoenix"
import socket from "../socket"
import storage from "../storage"

NAMES = [
  "bat", "bear", "bird", "bone", "bull", "camel", "cat", "cow", "crab", "crocodile", "dog", "dolphin",
  "elephant", "elk", "fish", "fox", "frog", "giraffe", "gorilla", "jellyfish", "kangaroo", "lemur",
  "lion", "monkey", "octopus", "owl", "panda", "panther", "parrot", "paw", "pelican", "penguin", "pig",
  "pigeon", "rhino", "rooster", "seahorse", "seal", "shrimp", "snail", "snake", "squid", "squirrel",
  "tiger", "turtle", "whale", "woodpecker", "zebra"
]

randomName = ->
  index = parseInt(Math.random() * NAMES.length)
  NAMES[index]

export default
  data: ->
    channel: null
    users: []
    username: randomName()

  mounted: ->
    payload = {@username, user_id: @userId}
    @channel = socket.channel("game:#{@id}", payload)

    @channel.join()
      .receive("ok", @onJoin)
      .receive("error", @onChannelError)
    @updateUsername()

    @presence = new Presence(@channel)
    @presence.onSync(@onPresenceSync)

  beforeDestroy: ->
    @channel.leave()

  computed:
    id: ->
      @$route.params.id

    userId: ->
      storage.getUserId()

  methods:
    onJoin: (_response) ->
      console.log "join"

    onChannelError: (response) ->
      console.error "error", response

    onPresenceSync: (presence) ->
      users = []
      @presence.list (id, {metas: [first, ...rest]}) ->
        count = rest.length + 1
        {username} = first
        users.push({id, username, count})
      @users = users

    updateUsername: ->
      @channel.push("update", {@username})
</script>

<style lang="scss">
h2 {
  color: #666;
}
</style>
