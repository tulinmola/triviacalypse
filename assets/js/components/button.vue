<template>
  <li :class="klass">
    <a href="#" @click.prevent="$emit('action')">
      <slot></slot>
    </a>
  </li>
</template>

<script lang="coffee">
export default
  props:
    type: default: "primary"

  computed:
    types: ->
      @type.split(" ")

    klass: ->
      typeKlasses = @types.map (type) -> "button-#{type}"
      ["button"].concat(typeKlasses)
</script>

<style lang="scss">
.button {
  border-radius: $button-height * 0.5;
  margin: $padding 0;
  transition: color $transition-time, background-color $transition-time;

  a {
    display: block;
    height: $button-height;
    line-height: $button-height;
    text-align: center;
    text-decoration: none;
    color: inherit;
    font-weight: $medium-weight;
  }

  &:active {
    animation: click-animation 0.4s;
  }
}

.button-primary {
  background-color: $accent-color;
  border: 1px solid $accent-color;
  color: $inverted-primary-color;

  @include hover {
    background-color: $background-color;
    color: $accent-color;
  }
}

.button-secondary {
  border: 1px solid $accent-color;
  background-color: $background-color;
  color: $accent-color;

  @include hover {
    background-color: $accent-color;
    color: $inverted-primary-color;
  }

  &.button-danger {
    color: $danger-color;
    border-color: $danger-color;

    @include hover {
      background-color: $danger-color;
      color: $inverted-primary-color;
    }
  }
}
</style>
