import uuid from "./uuid"

localStorage = window.localStorage

set = (key, value) -> localStorage.setItem(key, value)
get = (key, defValue) -> localStorage.getItem(key) || defValue
reset = (key) -> localStorage.removeItem(key)
clear =  -> localStorage.clear()

getUserId = ->
  id = get("userId")
  unless id
    id = uuid()
    set("userId", id)
  id

export default {
  clear,
  getUserId
}
