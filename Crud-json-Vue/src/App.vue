<template>
  <div id="app">
    <CrudComponent />
  </div>
</template>

<script>
import CrudComponent from './components/CrudComponent.vue';

export default {
  components: {
    CrudComponent,
  },
};
</script>

<style scoped>
@import '../public/style.css'; 
</style>
