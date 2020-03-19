<template>
  <transition-group v-if="games" name="flip-list" tag="ul" class="games">
    <li v-for="game in sortedGames" :key="game.id" :data-game-id="game.id">
      <router-link :to="{name: 'game', params: {id: game.id}}">
        <i>&#x276F;</i>
        <span class="ellipsis">Created by <em>{{ game.creator_username }}</em></span>
        <time>{{ timeago(game) }} with {{ playerCount(game) }}</time>
      </router-link>
    </li>
    <li v-if="games.length == 0" key="no-games" class="empty">
      There are no available games. Why don't you create a new one?
    </li>
  </transition-group>
  <ul v-else class="games">
    <li class="placeholder"></li>
    <li class="placeholder"></li>
    <li class="placeholder"></li>
  </ul>
</template>

<script lang="coffee">
import {format} from "timeago.js"
import _ from "lodash"

export default
  props:
    games: default: null

  computed:
    sortedGames: ->
      _.orderBy(@games, "inserted_at", "desc")

  methods:
    timeago: (game) ->
      format(game.inserted_at)

    playerCount: (game) ->
      count = game.player_count
      if count == 1 then "1 player" else "#{count} players"
</script>

<style lang="scss">
.games {
  margin-bottom: $margin;

  li {
    display: block;
    transition: background-color $transition-time;

    &:nth-child(2n) {
      background-color: mix($background-color, $primary-color, 96%);
    }
  }

  .placeholder {
    padding: $padding;
    height: 72px;

    &:before, &:after {
      display: block;
    }

    &:before {
      width: 128px;
      height: 20px;
      margin: 2px 0;
    }

    &:after {
      width: 96px;
      height: 16px;
      margin: 2px 0;
    }

    &:nth-child(2n):before, &:nth-child(2n):after {
      background-color: $background-color;
    }
  }

  a {
    display: block;
    padding: $padding;
    text-decoration: none;
    color: inherit;
    transition: color $transition-time, background-color $transition-time;

    &:hover, &:active {
      background-color: $accent-color;
      color: $background-color;

      time {
        color: $background-color;
        opacity: 0.5;
      }
    }
  }

  .empty {
    padding: $padding;
    text-align: center;
    color: $secondary-color;
  }

  span, time, i {
    display: block;
  }

  i {
    float: right;
    opacity: 0.22;
  }

  span {
    margin-right: 24px;
  }

  time {
    font-size: 11px;
    line-height: 16px;
    color: $secondary-color;
    transition: opacity $transition-time;
  }
}
</style>
