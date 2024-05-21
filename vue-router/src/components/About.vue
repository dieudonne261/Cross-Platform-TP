<template>
  <div>
    <h1>About Page</h1>
    <button @click="goToHome">Go to Home</button>
  </div>
</template>

<script setup>
import { useRoute, useRouter } from 'vue-router'

const router = useRouter()

function goToHome() {
  router.push('/')
}
</script>
