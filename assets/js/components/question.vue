<template>
  <div class="question">
    <span class="question-category" v-html="category"/>
    <span class="question-difficulty">Score: <em>{{ score }} points</em></span>

    <p v-html="text"/>
    <div class="question-progress" :style="{width: progress + '%'}"></div>

    <ul class="question-answers">
      <li v-for="answer in answers" :key="answer" :class="{current: currentAnswer == answer}">
        <a v-html="answer" @click.prevent="setCurrentAnswer(answer)" href="#"/>
      </li>
    </ul>
  </div>
</template>

<script lang="coffee">
QUESTION_TIME = 20 * 1000

now = -> new Date().getTime()

export default
  data: ->
    currentAnswer: null
    interval: null
    startTime: null
    progress: 0

  mounted: ->
    @$nextTick =>
      @startTime = now()
      @interval = setInterval(@updateProgress, 200)

  watch:
    question: ->
      @startTime = now()

  beforeDestroy: ->
    clearInterval(@interval) if @interval

  props:
    question: Object

  computed:
    category: ->
      @question.category

    difficulty: ->
      @question.difficulty

    score: ->
      @question.score

    text: ->
      @question.text

    answers: ->
      @question.answers

  methods:
    setCurrentAnswer: (@currentAnswer) ->
      @$emit("answer", @currentAnswer)

    updateProgress: ->
      currentTime = now()
      t = (currentTime - @startTime) / QUESTION_TIME
      @progress = Math.min(100 * t, 100)
</script>

<style lang="scss">
.question {
  overflow: hidden;
  text-align: center;

  p {
    font-size: 21px;
    line-height: 32px;
    padding: 0 $padding;
    margin-bottom: $margin;
  }
  margin-bottom: $margin;
}

.question-category, .question-difficulty {
  display: block;
}

.question-category {
  font-size: 16px;
  font-weight: $medium-weight;
  line-height: 20px;
  padding: 13px $padding 0;
}

.question-difficulty {
  font-size: 11px;
  line-height: 22px;
  margin-bottom: $padding;
  color: $secondary-color;

  em {
    font-weight: $medium-weight;
  }
}

.question-progress {
  height: 4px;
  background-color: $accent-color;
  transition: width 0.2s;
}

.question-answers {
  font-size: 16px;
  line-height: 24px;

  $border-color: rgba($primary-color, 0.1);

  li {
    border-top: 1px solid $border-color;
    transition: color $transition-time, background-color $transition-time;

    &:last-child {
      border-bottom: 1px solid $border-color;
    }

    &:hover, &.current {
      background-color: $accent-color;
      color: $background-color;
    }

    &.current {
      animation: click-animation 0.4s;
    }
  }

  a {
    display: block;
    color: inherit;
    text-decoration: none;
    padding: $padding $padding;
  }
}
</style>
