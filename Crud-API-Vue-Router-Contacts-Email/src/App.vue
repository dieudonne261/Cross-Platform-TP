<template>
  <div id="app">
    <router-view></router-view>
  </div>
</template>

<script>
import '../public/bootstrap.bundle.js';
export default {
  name: 'App'
};
</script>

<style>
@import "../public/bootstrap.min.css";
#app {
  font-family: sans-serif;
  overflow-y: hidden;
  height: 100vh;
}
body{
  overflow-y: hidden
}
</style>