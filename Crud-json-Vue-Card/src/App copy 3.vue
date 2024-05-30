<template>
  <div id="app">
    <div class="modal fade" :class="{ show: showModal }" tabindex="-1" role="dialog" aria-hidden="true" ref="exampleModal">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">
              {{ modalAction === 'add' ? 'Ajouter une nouvelle entrée' : 'Mettre à jour l\'entrée' }}
            </h5>
            <button type="button" class="btn-close" @click="closeModal"></button>
          </div>
          <div class="modal-body">
            <input v-model="form.name" class="form-control" type="text" placeholder="Nom" />
            <input v-model="form.email" class="form-control" type="text" placeholder="Email" />
            <input v-model="form.devise" class="form-control" type="text" placeholder="Devise" />
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" @click="closeModal">Fermer</button>
            <button type="button" class="btn btn-primary" @click="saveEntryOrUpdate">Enregistrer</button>
          </div>
        </div>
      </div>
    </div>
    <div class="container bg-dark mt-4" style="background-color: black;">
      <h1 class="mb-3">CRUD JSON</h1>
      <button class="btn btn-primary mb-3" @click="openModal('add')">Ajouter</button>
      <div class="mb-3">
        <input v-model="searchQuery" class="form-control" type="text" placeholder="Rechercher" />
      </div>
      <div class="row">
        <div v-for="item in filteredData" :key="item.id" class="col-md-3 my-3">
          <div class="card ">
            <div class="card-body">
              <h5 class="card-title">{{ item.name }}</h5>
              <p class="card-text">Email: {{ item.email }}</p>
              <p class="card-text">Devise: {{ item.devise }}</p>
              <button class="btn btn-primary" @click="openModal('update', item)">Mettre à jour</button>
              <button class="btn btn-primary" @click="deleteEntry(item.id)">Supprimer</button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import "../public/bootstrap.min.js";
export default {
  data() {
    return {
      data: [],
      searchQuery: "",
      modalAction: "",
      showModal: false,
      form: {
        name: "",
        email: "",
        devise: "",
      },
    };
  },
  computed: {
    filteredData() {
      const query = this.searchQuery.toLowerCase();
      return this.data.filter((item) => 
        item.name.toLowerCase().includes(query) ||
        item.email.toLowerCase().includes(query) ||
        item.devise.toLowerCase().includes(query)
      );
    },
  },
  created() {
    this.loadData();
  },
  methods: {
    loadData() {
      fetch("/data.json")
        .then((response) => response.json())
        .then((jsonData) => {
          this.data = jsonData;
        })
        .catch((error) => console.error("Erreur de chargement des données:", error));
    },
    openModal(action, item = null) {
      this.modalAction = action;
      this.showModal = true;
      if (action === "update" && item) {
        this.form = { ...item };
      } else {
        this.form = {
          name: "",
          email: "",
          devise: "",
        };
      }
      const modal = this.$refs.exampleModal;
      const bsModal = new bootstrap.Modal(modal);
      bsModal.show();
    },
    saveEntryOrUpdate() {
      if (this.modalAction === "add") {
        this.saveEntry();
      } else {
        this.saveUpdatedEntry();
      }
    },
    saveEntry() {
      const newEntry = {
        id: Date.now(),
        name: this.form.name,
        email: this.form.email,
        devise: this.form.devise,
      };
      this.data.push(newEntry);
      this.closeModal();
    },
    saveUpdatedEntry() {
      const index = this.data.findIndex((item) => item.id === this.form.id);
      if (index !== -1) {
        this.data[index] = { ...this.form };
        this.closeModal();
      }
    },
    deleteEntry(id) {
      const index = this.data.findIndex((item) => item.id === id);
      if (index !== -1) {
        this.data.splice(index, 1);
      }
    },
    closeModal() {
      const modal = this.$refs.exampleModal;
      const bsModal = new bootstrap.Modal(modal);
      bsModal.hide();
      this.showModal = false;
    },
  },
};
</script>

<style scoped>
@import "../public/bootstrap.min.css";
</style>
