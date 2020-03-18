import axios from "axios"

apiUrl = (path) ->
  "/api#{path}"

axiosCall = (path, params, method) ->
  url = apiUrl(path)
  fn = axios[method]
  fn(url, params)
    .then ({data}) ->
      data.data

get = (path, params) ->
  axiosCall(path, params, "get")

post = (path, params) ->
  axiosCall(path, params, "post")

patch = (path, params) ->
  axiosCall(path, params, "patch")

doDelete = (path, params) ->
  axiosCall(path, params, "delete")

export default
  createGame: (params) -> post("/games", {game: params})

  startGame: (game) -> post("/games/#{game.id}/start")
