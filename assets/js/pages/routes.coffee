import Home from "../components/home"
import Game from "../components/game"

export default [
  {path: "/", component: Home, name: "home"}
  {path: "/game/:id", component: Game, name: "game"}
]
