import css from "../css/app.css"

import "phoenix_html"

import Vue from "vue"
import VueRouter  from "vue-router"

Vue.use(VueRouter)

import Buttons from "./components/buttons"
import Button from "./components/button"
import Overlay from "./components/overlay"
import ConnectionError from "./components/connection_error"

Vue.component("t-buttons", Buttons)
Vue.component("t-button", Button)
Vue.component("t-overlay", Overlay)
Vue.component("t-connection-error", ConnectionError)

import Page from "./pages"
window.vm = new Vue(Page)
