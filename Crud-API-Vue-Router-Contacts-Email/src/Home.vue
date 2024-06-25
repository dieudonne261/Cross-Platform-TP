<template>
  <div class="container text-center mt-4">
    <h2>Mes contacts</h2>
    <div class="d-grid lead fs-5">
      <div>Nom : {{ user.name }}</div>
      <div>Email : {{ user.email }}</div>
      <div class="dropdown-center">
        <button class="btn btn-success btn-sm col-4 mx-auto m-1" data-bs-toggle="dropdown" data-bs-auto-close="outside" aria-haspopup="true" aria-expanded="false">Nouveau</button>
        <div class="dropdown-menu">
          <form class="px-4 py-3 text-center" @submit.prevent="addContact">
            <div class="row align-items-start text-center">
              <div class="col d-grid align-items-center text-center mb-3">
                <img :src="`/avatar/blue.png`" width="40px">
                <input class="mt-1" type="radio" value="blue" name="avataricon" v-model="newContact.avatar">
              </div>
              <div class="col d-grid align-items-center text-center">
                <img :src="`/avatar/green.png`" width="40px">
                <input class="mt-1" type="radio" value="green" name="avataricon" v-model="newContact.avatar">
              </div>
              <div class="col d-grid align-items-center text-center">
                <img :src="`/avatar/red.png`" width="40px">
                <input class="mt-1" type="radio" value="red" name="avataricon" v-model="newContact.avatar">
              </div>
              <div class="col d-grid align-items-center text-center">
                <img :src="`/avatar/purple.png`" width="40px">
                <input class="mt-1" type="radio" value="purple" name="avataricon" v-model="newContact.avatar">
              </div>
            </div>
            <div class="form-group">
              <input type="text" class="form-control" placeholder="Nom" v-model="newContact.nom" required>
            </div>
            <div v-for="(telephone, index) in newContact.telephones" :key="index" class="form-group">
              <input type="text" class="form-control my-2" placeholder="Telephone" v-model="telephone.numero" required>
            </div>
            <button type="button" class="btn btn-secondary btn-sm  mt-2 mx-1" @click="addPhoneField">Ajouter un numéro</button>
            <button type="submit" class="btn btn-primary btn-sm mt-2 mx-1">{{ editMode ? 'Enregistrer' : 'Ajouter' }}</button>
          </form>
        </div>
      </div>
    </div>
    <div class="m-2">
      <input class="form-control form-control-lg" type="text" placeholder="Rechercher" v-model="searchQuery" />
    </div>
    <hr>
    <div style="height:295px;max-height: 295px; overflow-y: auto;" class="ms-1 pe-1">
      <div v-for="contact in filteredContacts" :key="contact.id" class="my-1 p-2 d-flex border rounded-2 align-items-center btn-light btn" type="button" data-bs-toggle="modal" :data-bs-target="'#contactModal' + contact.id">
        <img :src="`/avatar/${contact.avatar}.png`" width="60px" class="border-end pe-2" alt="Photo de profil">
        <div class="fs-4 ms-2 text-secondary">{{ contact.nom }}</div>
      </div>
    </div>
    <hr>
    <footer>
      <div class="lead" style="font-size: 12px; margin-top: -5px">{{ token }}</div>
      <button @click="logout" class="btn btn-danger btn-sm col-4 mx-auto m-1">Se deconnecter</button>
    </footer>

    <div v-for="contact in filteredContacts" :key="contact.id" class="modal fade" :id="'contactModal' + contact.id" tabindex="-1" aria-labelledby="contactModalLabel" aria-hidden="true">
      <div class="modal-dialog modal-dialog-centered modal-sm">
        <div class="modal-content">
          <div class="modal-body">
            <img :src="`/avatar/${contact.avatar}.png`" width="150px" style="background-color: white; border: 5px solid white; border-radius: 500px; margin-top: -90px;" alt="Photo de profil">
            <h4 class="m-1 lead">{{ contact.nom }}</h4>
            <div v-for="phone in contact.telephones" :key="phone.id">
              <h6>{{ phone.numero }}</h6>
            </div>
            <div class="d-grid gap-2 mx-auto">
              <button class="btn btn-primary btn-sm" data-bs-target="#editModal" data-bs-toggle="modal" @click="prepareEditContact(contact)">Modifier</button>
              <button class="btn btn-danger btn-sm" @click="deleteContact(contact.id)">Supprimer</button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="modal fade" id="editModal" aria-hidden="true" aria-labelledby="editModalLabel" tabindex="-1">
      <div class="modal-dialog modal-dialog-centered modal-sm">
        <div class="modal-content">
          <div class="modal-body">
            <form class=" text-center" @submit.prevent="updateContact">
              <div class="row align-items-start text-center">
                <div class="col d-grid align-items-center  text-center mb-3">
                  <img :src="`/avatar/blue.png`"  width="40px" class="mx-1">
                  <input class="mt-1" type="radio" value="blue" name="avataricon" v-model="newContact.avatar">
                </div>
                <div class="col d-grid align-items-center text-center">
                  <img :src="`/avatar/green.png`" width="40px" class="mx-1">
                  <input class="mt-1" type="radio" value="green" name="avataricon" v-model="newContact.avatar">
                </div>
                <div class="col d-grid align-items-center text-center">
                  <img :src="`/avatar/red.png`" width="40px" class="mx-1">
                  <input class="mt-1" type="radio" value="red" name="avataricon" v-model="newContact.avatar">
                </div>
                <div class="col d-grid align-items-center text-center">
                  <img :src="`/avatar/purple.png`" width="40px" class="mx-1">
                  <input class="mt-1" type="radio" value="purple" name="avataricon" v-model="newContact.avatar">
                </div>
              </div>
              <div class="form-group">
                <input type="text" class="form-control" placeholder="Nom" v-model="newContact.nom" required>
              </div>
              <div v-for="(telephone, index) in newContact.telephones" :key="index" class="form-group">
                <input type="text" class="form-control my-2" placeholder="Telephone" v-model="telephone.numero" required>
              </div>
              <button type="button" class="btn btn-secondary btn-sm mt-2 mx-1" @click="addPhoneField">Ajouter un numéro</button>
              <button type="submit" class="btn btn-primary btn-sm mt-2 mx-1">Enregistrer</button>
            </form>
          </div>
        </div>
      </div>
    </div>

    <div v-if="showNotification" :class="`toast show m-3 align-items-center text-bg-${notificationType} border-${notificationType} position-fixed bottom-0 end-0 `" role="alert" aria-live="assertive" aria-atomic="true">
      <div class="d-flex">
        <div class="toast-body">
          {{ notificationMessage }}
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import '../public/bootstrap.bundle.js';

export default {
  name: 'Home',
  data() {
    return {
      user: {},
      token: '',
      contacts: [],
      searchQuery: '',
      newContact: {
        avatar: 'blue',
        nom: '',
        telephones: [{ numero: '' }]
      },
      editMode: false,
      currentContact: null,
      showNotification: false,
      notificationMessage: '',
      notificationType: 'success'
    };
  },
  computed: {
    filteredContacts() {
    }
  },
  created() {
    this.fetchUser();
    this.fetchContacts();
  },
  methods: {
    async fetchUser() {
      try {
        const token = localStorage.getItem('token');
        this.token = token;
        const response = await fetch('http://127.0.0.1:8000/api/user', {
          headers: {
            Authorization: `Bearer ${token}`
          }
        });
        if (response.ok) {
          this.user = await response.json();
        }
      } catch (error) {
        console.error('Error:', error);
      }
    },
    async fetchContacts() {
      try {
        const token = localStorage.getItem('token');
        const response = await fetch('http://127.0.0.1:8000/api/contacts', {
          headers: {
            Authorization: `Bearer ${token}`
          }
        });
        if (response.ok) {
          this.contacts = await response.json();
        }
      } catch (error) {
        console.error('Error:', error);
      }
    },
    async addContact() {
      try {
        const token = localStorage.getItem('token');
        const contactData = {
          avatar: this.newContact.avatar,
          nom: this.newContact.nom,
          telephones: this.newContact.telephones.map(phone => phone.numero)
        };
        const response = await fetch('http://127.0.0.1:8000/api/contacts', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            Authorization: `Bearer ${token}`
          },
          body: JSON.stringify(contactData)
        });
        if (response.ok) {
          const newContact = await response.json();
          this.contacts.push(newContact);
          this.showNotificationMessage('Contact ajouté', 'success');
          this.newContact = {
            avatar: 'blue',
            nom: '',
            telephones: [{ numero: '' }]
          };
        }
      } catch (error) {
        console.error('Error:', error);
      }
    },
    async deleteContact(contactId) {
      try {
        const token = localStorage.getItem('token');
        const response = await fetch(`http://127.0.0.1:8000/api/contacts/${contactId}`, {
          method: 'DELETE',
          headers: {
            Authorization: `Bearer ${token}`
          }
        });
        if (response.ok) {
          this.contacts = this.contacts.filter(contact => contact.id !== contactId);
          this.showNotificationMessage('Contact supprimé', 'danger');
          this.closeModal('contactModal' + contactId);
        }
      } catch (error) {
        console.error('Error:', error);
      }
    },
    prepareEditContact(contact) {
      this.newContact = { ...contact, telephones: contact.telephones.map(phone => ({ numero: phone.numero })) };
      this.editMode = true;
      this.currentContact = contact;
    },
    async updateContact() {
      try {
        const token = localStorage.getItem('token');
        const contactData = {
          avatar: this.newContact.avatar,
          nom: this.newContact.nom,
          telephones: this.newContact.telephones.map(phone => phone.numero)
        };
        const response = await fetch(`http://127.0.0.1:8000/api/contacts/${this.currentContact.id}`, {
          method: 'PUT',
          headers: {
            'Content-Type': 'application/json',
            Authorization: `Bearer ${token}`
          },
          body: JSON.stringify(contactData)
        });
        if (response.ok) {
          const updatedContact = await response.json();
          const index = this.contacts.findIndex(contact => contact.id === this.currentContact.id);
          if (index !== -1) {
            this.contacts.splice(index, 1, updatedContact);
          }
          this.showNotificationMessage('Contact modifié', 'success');
          this.editMode = false;
          this.currentContact = null;
          this.newContact = {
            avatar: 'blue',
            nom: '',
            telephones: [{ numero: '' }]
          };
          this.closeModal('editModal');
        }
      } catch (error) {
        console.error('Error:', error);
      }
    },
    addPhoneField() {
      this.newContact.telephones.push({ numero: '' });
    },
    hideNotification() {
      this.showNotification = false;
    },
    showNotificationMessage(message, type) {
      this.notificationMessage = message;
      this.notificationType = type;
      this.showNotification = true;
      setTimeout(this.hideNotification, 5000);
    },
    async logout() {
      try {
        const token = localStorage.getItem('token');
        await fetch('http://127.0.0.1:8000/api/logout', {
          method: 'POST',
          headers: {
            Authorization: `Bearer ${token}`
          }
        });
        localStorage.removeItem('token');
        this.$router.push({ name: 'Login' });
      } catch (error) {
        console.error('Logout failed:', error);
      }
    },
    closeModal(modalId) {
      const modalElement = document.getElementById(modalId);
      const modalInstance = bootstrap.Modal.getInstance(modalElement);
      if (modalInstance) {
        modalInstance.hide();
      }
    }
  }
};
</script>

<style scoped>
.container {
  max-width: 400px;
  height: 100vh;
}
body {
  overflow-y: hidden;
  margin: 0;
}
</style>