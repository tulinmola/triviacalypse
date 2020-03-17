NAMES = [
  "bat", "bear", "bird", "bone", "bull", "camel", "cat", "cow", "crab", "crocodile", "dog", "dolphin",
  "elephant", "elk", "fish", "fox", "frog", "giraffe", "gorilla", "jellyfish", "kangaroo", "lemur",
  "lion", "monkey", "octopus", "owl", "panda", "panther", "parrot", "paw", "pelican", "penguin", "pig",
  "pigeon", "rhino", "rooster", "seahorse", "seal", "shrimp", "snail", "snake", "squid", "squirrel",
  "tiger", "turtle", "whale", "woodpecker", "zebra"
]

export default
  random: ->
    index = parseInt(Math.random() * NAMES.length)
    NAMES[index]
