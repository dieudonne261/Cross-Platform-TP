<template>
    <div>
        <div id="modal" class="modal" v-if="showModal">
            <div class="modal-content">
                <template v-if="modalAction === 'add'">
                    <h2>Ajouter une nouvelle entrée</h2>
                    <input v-model="form.name" type="text" placeholder="Nom" />
                    <input v-model="form.email" type="text" placeholder="Email" />
                    <input v-model="form.devise" type="text" placeholder="Devise" />
                    <button @click="saveEntry">Enregistrer</button>
                </template>
                <template v-else-if="modalAction === 'update'">
                    <h2>Mettre à jour l'entrée</h2>
                    <input v-model="form.name" type="text" placeholder="Nom" />
                    <input v-model="form.email" type="text" placeholder="Email" />
                    <input v-model="form.devise" type="text" placeholder="Devise" />
                    <button @click="saveUpdatedEntry">Enregistrer</button>
                </template>
            </div>
        </div>

        <h1>CRUD JSON</h1>
        <button @click="openModal('add')">Ajouter</button>
        <div class="rech">
        <input v-model="searchQuery" type="text" placeholder="Rechercher" />
        </div>

        <div id="data-list">
            <table>
                <tr>
                <th>NAME</th>
                <th>EMAIL</th>
                <th>DEVICE</th>
                <th>ACTION</th>
                </tr>
                <tr v-for="item in filteredData" :key="item.id">
                <td>{{ item.name }}</td>
                <td>{{ item.email }}</td>
                <td>{{ item.devise }}</td>
                <td>
                    <button @click="openModal('update', item)">Update</button>
                    <button @click="deleteEntry(item.id)">Delete</button>
                </td>
                </tr>
            </table>
        </div>
    </div>
</template>
  
<script>
export default {
  data() {
    return {
      data: [],
      searchQuery: '',
      showModal: false,
      modalAction: '',
      form: {
        name: '',
        email: '',
        devise: ''
      }
    };
  },
  computed: {
    filteredData() {
      return this.data.filter(item => {
        return (
          item.name.toLowerCase().includes(this.searchQuery.toLowerCase()) ||
          item.email.toLowerCase().includes(this.searchQuery.toLowerCase()) ||
          item.devise.toLowerCase().includes(this.searchQuery.toLowerCase())
        );
      });
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
      this.showModal = true;
      if (action === 'update' && item) {
        this.form = { ...item };
      } else {
        this.form = { name: '', email: '', devise: '' };
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
      } else {
        console.error('ID non trouvé :', this.form.id);
      }
    },
    deleteEntry(id) {
      const index = this.data.findIndex(item => item.id === id);
      if (index !== -1) {
        this.data.splice(index, 1);
      }
    },
    closeModal() {
      this.showModal = false;
    }
  }
};
</script>
  
<style scoped>
body {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}
#container {
    width: 80%;
    margin: 0 auto;
}
.rech {
    display: flex;
}

button {
    margin: 5px;
    padding: 10px 20px;
    background-color: rgb(0, 140, 255);
    color: white;
    border-radius: 10px;
    border: none;
}
button:hover {
    background-color: rgb(3, 80, 143);
}

input[type=text] {
    width: 100%;
    padding: 12px 20px;
    margin: 8px 0;
    box-sizing: border-box;
}

table, td, th {
    border: 1px solid;
}

table {
    width: 100%;
    border-collapse: collapse;
    text-align: center;
}

.modal {
    display: flex;
    align-items: center;
    justify-content: center;
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background-color: rgba(0, 0, 0, 0.5);
}

.modal-content {
    background-color: white;
    padding: 20px;
    border-radius: 10px;
    text-align: center;
}

</style>