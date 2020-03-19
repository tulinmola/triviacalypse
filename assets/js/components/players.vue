<template>
  <transition-group v-if="players" name="flip-list" tag="ul" class="players">
    <li v-for="player in sortedPlayers" :key="player.id" :data-user-id="player.id">
      <dl>
        <dd>{{ player.score }}</dd>
        <dt class="ellipsis">{{ player.username }}</dt>
      </dl>
    </li>
  </transition-group>
  <ul v-else class="players">
    <li class="placeholder"></li>
    <li class="placeholder"></li>
    <li class="placeholder"></li>
  </ul>
</template>

<script lang="coffee">
import _ from "lodash"

export default
  props:
    players: default: null

  computed:
    sortedPlayers: ->
      _.orderBy(@players, "score", "desc")
</script>

<style lang="scss">
.players {
  margin-bottom: $margin;

  li {
    display: block;
    padding: $padding;
    transition: background-color $transition-time, transform $transition-time;

    &:nth-child(2n) {
      background-color: mix($background-color, $primary-color, 96%);
    }
  }

  .placeholder {
    height: 56px;

    &:before, &:after {
      height: 24px;
    }

    &:before {
      width: 80px;
      float: left;
    }

    &:after {
      width: 24px;
      float: right;
    }

    &:nth-child(2n):before, &:nth-child(2n):after {
      background-color: $background-color;
    }
  }

  dl {
    overflow: hidden;
    line-height: 24px;
  }

  dd, dt {
    display: block;
  }

  dt {
    margin-right: 48px;
  }

  dd {
    float: right;
  }
}
</style>
