<template>
  <div v-if="form">
    <h1>Mettre à jour l'entrée</h1>
    <div class="form-group">
      <input v-model="form.name" class="form-control" type="text" placeholder="Nom" />
    </div>
    <div class="form-group">
      <input v-model="form.email" class="form-control" type="text" placeholder="Email" />
    </div>
    <div class="form-group">
      <button class="btn" @click="updateEntry">Enregistrer</button>
      <router-link to="/" class="btn">Retour</router-link>
    </div>
  </div>
  <div v-else>
    Chargement...
  </div>
</template>

<script>
export default {
  props: ['id'],
  data() {
    return {
      form: null,
    };
  },
  created() {
    this.loadEntry();
  },
  methods: {
    loadEntry() {
      fetch(`http://127.0.0.1:8000/api/users/${this.id}`)
        .then((response) => response.json())
        .then((jsonData) => {
          this.form = jsonData;
        })
        .catch((error) => {
          console.error('Erreur lors du chargement des données:', error);
        });
    },
    updateEntry() {
      fetch(`http://127.0.0.1:8000/api/users/${this.form.id}`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(this.form)
      })
      .then(response => response.json())
      .then(jsonData => {
        console.log("Succès: Entrée mise à jour", jsonData);
        this.$router.push('/');
      })
      .catch(error => console.error('Erreur lors de la mise à jour:', error));
    },
  },
};
</script>

<style scoped>
.form-group {
  margin-bottom: 15px;
}
.btn {
  border-radius: 10px;
  box-shadow: 0 0 20px rgba(29, 29, 29, 0.397);
  margin: 5px;
}
</style>