import { createRouter, createWebHistory } from 'vue-router';
import Login from './Login.vue';
import Register from './Register.vue';
import Home from './Home.vue';
import Recovery from './Recovery.vue';
import ResetPassword from './ResetPassword.vue';

const routes = [
  {
    path: '/',
    name: 'Login',
    component: Login,
    beforeEnter: (to, from, next) => {
      const token = localStorage.getItem('token');
      if (token) {
        next({ name: 'Home' });
      } else {
        next();
      }
    }
  },
  {
    path: '/register',
    name: 'Register',
    component: Register,
    beforeEnter: (to, from, next) => {
      const token = localStorage.getItem('token');
      if (token) {
        next({ name: 'Home' });
      } else {
        next();
      }
    }
  },
  {
    path: '/recovery',
    name: 'Recovery',
    component: Recovery,
    beforeEnter: (to, from, next) => {
      const token = localStorage.getItem('token');
      if (token) {
        next({ name: 'Home' });
      } else {
        next();
      }
    }
  },
  {
    path: '/reset-password',
    name: 'ResetPassword',
    component: ResetPassword,
  },
  {
    path: '/home',
    name: 'Home',
    component: Home,
    meta: {
      requiresAuth: true
    }
  }
];

const router = createRouter({
  history: createWebHistory(),
  routes
});

router.beforeEach((to, from, next) => {
  const token = localStorage.getItem('token');
  if (to.matched.some(record => record.meta.requiresAuth) && !token) {
    next({ name: 'Login' });
  } else {
    next();
  }
});

export default router;
