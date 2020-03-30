<template>
  <transition name="overlay">
    <div class="overlay">
      <div class="overlay-container">
        <div class="container">
          <slot name="header">
            default header
          </slot>
          <slot name="body">
            default body
          </slot>
        </div>
      </div>
    </div>
  </transition>
</template>

<script lang="coffee">
export default {}
</script>

<style lang="scss">
.overlay {
  position: fixed;
  z-index: 100;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba($primary-color, 0.9);
  color: $inverted-primary-color;
  display: table;
  transform: translate(0, 0);
  transition: all 1s ease;
}

.overlay-container {
  display: table-cell;
  vertical-align: middle;

  h2 {
    margin-bottom: $padding;
  }

  p {
    padding: 0 $padding $margin;

    a {
      color: inherit;
      font-weight: $medium-weight;
      text-decoration: none;
      white-space: nowrap;

      &:hover {
        text-decoration: underline;
      }
    }
  }
}

.overlay-button {
  display: inline-block;
  color: $inverted-primary-color;
  border: 1px solid $inverted-primary-color;
  height: $button-height;
  line-height: $button-height;
  border-radius: $button-height * 0.5;
  padding: 0 32px;
  margin: 0 0 $margin 50%;
  text-decoration: none;
  transform: translate(-50%, 0);
}

.overlay-enter, .overlay-leave-to {
  opacity: 0;
}

.overlay-enter .overlay-container,
.overlay-leave-to .overlay-container {
  -webkit-transform: scale(1.1);
  transform: scale(1.1);
}
</style>
