import axios from "axios"
import storage from "./storage"

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
  createGame: (params) ->
    user = storage.getCurrentUser()
    params = _.merge params,
      creator_id: user.id
      creator_username: user.username
    post("/games", game: params)

  deleteGame: (game) ->
    doDelete("/games/#{game.id}")

  startGame: (game, params) ->
    post("/games/#{game.id}/start", game: params)
