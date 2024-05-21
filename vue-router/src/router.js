import { createRouter, createWebHistory } from 'vue-router'

import HomeView from './components/Home.vue'
import AboutView from './components/About.vue'

const routes = [
  { path: '/', component: HomeView },
  { path: '/about', component: AboutView },
]

const router = createRouter({
  history: createWebHistory(),
  routes,
})

export default router
