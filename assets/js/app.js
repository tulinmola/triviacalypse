import css from "../css/app.css"

import "phoenix_html"

import Vue from "vue"
import VueRouter  from "vue-router"

Vue.use(VueRouter)

import Buttons from "./components/buttons"
import Button from "./components/button"

Vue.component("t-buttons", Buttons)
Vue.component("t-button", Button)

import Page from "./pages"
window.vm = new Vue(Page)
