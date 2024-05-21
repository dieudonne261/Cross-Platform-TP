<template>
  <h1>Hello App!</h1>
  <p>
    <strong>Current route path:</strong>  {{ $route.fullPath }}
  </p>
  <nav>
    <router-link to="/">Go to Home</router-link>
    <router-link to="/about">Go to About</router-link>
  </nav>
  <main>
    <router-view />
  </main>
</template>

<script>
export default {
  name: 'App',
};
</script>
