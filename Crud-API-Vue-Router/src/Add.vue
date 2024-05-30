<template>
  <div class="container">
    <h1>Ajouter une nouvelle entrée</h1>
    <div class="form-group">
      <input v-model="form.name" class="form-control" type="text" placeholder="Nom" />
    </div>
    <div class="form-group">
      <input v-model="form.email" class="form-control" type="text" placeholder="Email" />
    </div>
    <div class="form-group">
      <button class="btn" @click="saveEntry">Enregistrer</button>
      <router-link to="/" class="btn">Retour</router-link>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      form: {
        name: "",
        email: "",
      }
    }
  },
  methods: {
    saveEntry() {
      const newEntry = { ...this.form, password: "1234" };
      fetch("http://127.0.0.1:8000/api/users", {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(newEntry)
      })
      .then(response => response.json())
      .then(jsonData => {
        console.log("Element ajoutée", jsonData);
        this.$router.push('/');
      })
      .catch(error => console.log('Erreur lors de l\'enregistrement:', error));
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