<template>
    <div class="card">
      <div class="card-body">
        <h5 class="card-title">{{ provider.name }}</h5>
        <p class="card-text">{{ provider.email }}</p>
        <p class="card-text">{{ provider.devise }}</p>
        <button class="btn btn-warning" @click="$emit('update', provider)">Mettre à jour</button>
        <button class="btn btn-danger" @click="$emit('delete', provider.id)">Supprimer</button>
      </div>
    </div>
  </template>
  
  <script>
  export default {
    props: ['provider'],
  };
  </script>
  
  <style scoped>
  .card {
    margin-bottom: 1rem;
  }
  </style>
  