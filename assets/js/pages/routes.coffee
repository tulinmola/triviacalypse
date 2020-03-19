import Home from "./home"
import Game from "./game"

export default [
  {path: "/", component: Home, name: "home"}
  {path: "/game/:id", component: Game, name: "game"}
]
