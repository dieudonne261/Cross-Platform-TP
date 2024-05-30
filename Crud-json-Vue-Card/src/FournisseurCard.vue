<template>
    <div class="card">
      <div class="card-body">
        <h5 class="card-title">{{ fournisseur.name }}</h5>
        <p class="card-text">
          Email: {{ fournisseur.email }}<br>
          Devise: {{ fournisseur.devise }}
        </p>
        <button
          class="btn btn-warning"
          @click="updateFournisseur"
        >
          Mettre à jour
        </button>
        <button
          class="btn btn-danger"
          @click="deleteFournisseur"
        >
          Supprimer
        </button>
      </div>
    </div>
  </template>
  
  <script>
  export default {
    props: {
      fournisseur: {
        type: Object,
        required: true,
      },
    },
    methods: {
      updateFournisseur() {
        this.$emit('update', this.fournisseur);
      },
      deleteFournisseur() {
        this.$emit('delete', this.fournisseur.id);
      },
    },
  };
  </script>
  
  <style scoped>
  .card {
    margin-bottom: 20px;
  }
  </style>
  