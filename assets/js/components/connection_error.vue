<template>
  <div class="connection-error">
    Ouch! There was a connection error. Trying to reconnect.
  </div>
</template>

<script lang="coffee">
export default {}
</script>

<style lang="scss">
.connection-error {
  margin: 0 0 $margin;
  padding: $padding;
  font-size: 13px;
  line-height: 20px;
  text-align: center;
  background-color: mix($danger-color, $background-color, 50%);
  color: mix($danger-color, $primary-color, 50%);
  border-top: 1px solid $danger-color;
  border-bottom: 1px solid $danger-color;
}
</style>
