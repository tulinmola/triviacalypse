import uuid from "./uuid"
import names from "./names"

localStorage = window.localStorage

createRandomUser = ->
  user =
    id: uuid()
    username: names.random()
  setCurrentUser(user)
  user

set = (key, value) -> localStorage.setItem(key, value)
get = (key, defValue) -> localStorage.getItem(key) || defValue
reset = (key) -> localStorage.removeItem(key)
clear = -> localStorage.clear()

setCurrentUser = (user) -> set("currentUser", JSON.stringify(user))
getCurrentUser = -> JSON.parse(get("currentUser", "null")) || createRandomUser()
resetCurrentUser = -> reset("currentUser")

export default {
  clear,
  setCurrentUser, getCurrentUser, resetCurrentUser
}
