<template>
  <div class="container mt-5 text-center rounded-4 p-5 shadow">
    <h2>Réinitialisation du mot de passe</h2>
    <form @submit.prevent="sendResetLink">
      <div class="mb-3">
        <input type="email" placeholder="Email" class="form-control" v-model="email" required>
      </div>
      <button type="submit" class="btn btn-primary w-100">Envoyer le lien de réinitialisation</button>
    </form>
  </div>
</template>

<script>
export default {
  name: 'Recovery',
  data() {
    return {
      email: ''
    };
  },
  methods: {
    async sendResetLink() {
      try {
        const response = await fetch('http://127.0.0.1:8000/api/password/email', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json'
          },
          body: JSON.stringify({
            email: this.email
          })
        });
        if (response.ok) {
          alert('Lien de réinitialisation envoyé.');
        } else {
          alert('Erreur lors de l\'envoi du lien de réinitialisation.');
        }
      } catch (error) {
        console.error('Error :', error);
        alert('Erreur lors de l\'envoi du lien de réinitialisation.');
      }
    }
  }
};
</script>

<style scoped>
.container {
  max-width: 400px;
}
</style>