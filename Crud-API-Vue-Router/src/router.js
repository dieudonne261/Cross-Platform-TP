import { createRouter, createWebHistory } from 'vue-router';
import Home from './Home.vue';
import Add from './Add.vue';
import Update from './Update.vue';

const routes = [
  { path: '/', component: Home },
  { path: '/add', component: Add },
  { path: '/update/:id', component: Update, props: true },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;