<template>
  <div id="app">
    <div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
      <div class="modal-dialog" style="background-color: black;">
        <div class="modal-content" style="background-color: black;">
          <div class="modal-header">
            <h5 class="modal-title" id="exampleModalLabel">
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
            <button
              type="button"
              class="btn btn-primary"
              @click="modalAction === 'add' ? saveEntry() : saveUpdatedEntry()"
            >
              Enregistrer
            </button>
          </div>
        </div>
      </div>
    </div>

    <div class="container mt-4">
      <h1 class="mb-3">CRUD JSON</h1>
      <button class="btn btn-primary mb-3" data-bs-toggle="modal" data-bs-target="#exampleModal" @click="openModal('add')">
        Ajouter
      </button>
      <div class="mb-3">
        <input
          v-model="searchQuery"
          class="form-control"
          type="text"
          placeholder="Rechercher"
        />
      </div>

      <div>
        <table class="table table-striped">
          <thead>
            <tr>
              <th>Nom</th>
              <th>Email</th>
              <th>Devise</th>
              <th>Action</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="item in filteredData" :key="item.id">
              <td>{{ item.name }}</td>
              <td>{{ item.email }}</td>
              <td>{{ item.devise }}</td>
              <td>
                <button
                  class="btn btn-warning"
                  data-bs-toggle="modal"
                  data-bs-target="#exampleModal"
                  @click="openModal('update', item)"
                >
                  Mettre à jour
                </button>
                <button
                  class="btn btn-danger"
                  @click="deleteEntry(item.id)"
                >
                  Supprimer
                </button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      data: [],
      searchQuery: '',
      modalAction: '',
      showModal: false,
      form: {
        name: '',
        email: '',
        devise: ''
      }
    };
  },
  computed: {
    filteredData() {
      const query = this.searchQuery.toLowerCase();
      return this.data.filter(item =>
        item.name.toLowerCase().includes(query) ||
        item.email.toLowerCase().includes(query) ||
        item.devise.toLowerCase().includes(query)
      );
    }
  },
  created() {
    this.loadData();
  },
  methods: {
    loadData() {
      fetch('/data.json')
        .then(response => response.json())
        .then(jsonData => {
          this.data = jsonData;
        })
        .catch(error => console.error('Erreur de chargement des données:', error));
    },
    openModal(action, item = null) {
      this.modalAction = action;
      if (action === 'update' && item) {
        this.form = { ...item };
      } else {
        this.form = {
          name: '',
          email: '',
          devise: ''
        };
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
      const index = this.data.findIndex(item => item.id === this.form.id);
      if (index !== -1) {
        this.data[index] = { ...this.form };
        this.closeModal();
      }
    },
    deleteEntry(id) {
      const index = this.data.findIndex(item => item.id === id);
      if (index !== -1) {
        this.data.splice(index, 1);
      }
    },
    closeModal() {
      const modal = document.getElementById("exampleModal");
      if (modal) {
        const bsModal = bootstrap.Modal.getOrCreateInstance(modal);
        bsModal.hide();
      }
    }
  }
};
</script>

Maintenant Changer en CARD la liste des fournisseurs et utilise Changer en CARD la liste des fournisseurs