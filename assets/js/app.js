import css from "../css/app.css"

import "phoenix_html"

import Vue from "vue"
import VueRouter  from "vue-router"

Vue.use(VueRouter)

import Page from "./pages"
window.vm = new Vue(Page)
