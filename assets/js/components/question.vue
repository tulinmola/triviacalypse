<template>
  <div class="question">
    <span class="question-category" v-html="category"/>
    <span class="question-difficulty" v-html="difficulty"/>

    <p v-html="text"/>

    <ul>
      <li v-for="answer in answers" :key="answer" :class="{current: currentAnswer == answer}">
        <a v-html="answer" @click.prevent="setCurrentAnswer(answer)" href="#"/>
      </li>
    </ul>
  </div>
</template>

<script lang="coffee">
export default
  data: ->
    currentAnswer: null

  props:
    question: Object

  computed:
    category: ->
      @question.category

    difficulty: ->
      @question.difficulty

    text: ->
      @question.text

    answers: ->
      @question.answers

  methods:
    setCurrentAnswer: (@currentAnswer) ->
      @$emit("answer", @currentAnswer)
</script>

<style lang="scss">
.question {
  color: #333;
}

.question-category, .question-difficulty {
  display: block;
}
</style>
