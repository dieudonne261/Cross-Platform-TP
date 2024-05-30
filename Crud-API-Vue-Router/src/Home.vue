<template>
  <div class="container">
    <div class="container mt-4">
      <h1 class="mb-3">CRUD JSON</h1>
      <router-link to="/add" class="btn">Ajouter</router-link>
      <div class="mb-3">
        <input v-model="searchQuery" class="form-control" type="text" placeholder="Rechercher" />
      </div>
      <div class="list-group">
        <div v-for="item in filteredData" :key="item.id" class="list-group-item d-flex justify-content-between align-items-center">
          <div>
            <h5>{{ item.name }}</h5>
            <p>Email: {{ item.email }}</p>
          </div>
          <div>
            <button class="btn" @click="updateEntry(item)">Mettre à jour</button>
            <button class="btn" @click="deleteEntry(item.id)">Supprimer</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      data: [],
      searchQuery: "",
    };
  },
  computed: {
    filteredData() {
      const query = this.searchQuery.toLowerCase();
      return this.data.filter((item) =>
        (item.name && item.name.toLowerCase().includes(query))||
        (item.email && item.email.toLowerCase().includes(query))
      );
    },
  },
  created() {
    this.loadData();
  },
  methods: {
    loadData() {
      fetch("http://127.0.0.1:8000/api/users")
        .then((response) => response.json())
        .then((jsonData) => {
          this.data = jsonData;
        })
        .catch((error) =>
          console.log("Erreur lors du chargement des données:", error)
        );
    },
    updateEntry(item) {
      this.$router.push('/update/' + item.id);
    },
    deleteEntry(id) {
      fetch(`http://127.0.0.1:8000/api/users/${id}`, {
        method: 'DELETE',
      })
      .then(() => {
        this.data = this.data.filter((item) => item.id !== id);
        console.log("Element supprimée");
      })
      .catch(error => console.error('Erreur lors de la suppression:', error));
    },
  },
};
</script>

<style scoped>
@import "../public/bootstrap.min.css";

.container {
  font-family: sans-serif;
}
.btn {
  border-radius: 10px;
  box-shadow: 0 0 20px rgba(29, 29, 29, 0.397);
  margin: 20px;
}
.form-control {
  border-radius: 20px;
  margin: 5px;
}
.list-group-item {
  background-color: white;
  border-radius: 10px;
  box-shadow: 0 0 20px rgba(29, 29, 29, 0.397);
  margin: 10px 0;
  padding: 20px;
}
</style>