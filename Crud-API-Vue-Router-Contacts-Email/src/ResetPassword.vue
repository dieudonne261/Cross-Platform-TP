<template>
  <div class="container mt-5 text-center rounded-4 p-5 shadow">
    <h2>Réinitialiser le mot de passe</h2>
    <form @submit.prevent="resetPassword">
      <div class="mb-3">
        <input type="hidden" v-model="token">
        <input type="hidden" placeholder="Email" class="form-control" v-model="email" readonly>
        <input type="hidden" class="form-control" v-model="token" readonly>
      </div>
      <div class="mb-3">
        <input type="password" placeholder="Nouveau mot de passe" class="form-control" v-model="password" required>
      </div>
      <div class="mb-3">
        <input type="password" placeholder="Confirmer le mot de passe" class="form-control" v-model="password_confirmation" required>
      </div>
      <button type="submit" class="btn btn-primary w-100">Réinitialiser le mot de passe</button>
    </form>
  </div>
</template>

<script>
export default {
  name: 'ResetPassword',
  data() {
    return {
      token: '',
      email: '',
      password: '',
      password_confirmation: ''
    };
  },
  created() {
    this.token = this.$route.query.token;
    this.email = this.$route.query.email;
  },
  methods: {
    async resetPassword() {
      try {
        const response = await fetch('http://127.0.0.1:8000/api/password/reset', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json'
          },
          body: JSON.stringify({
            token: this.token,
            email: this.email,
            password: this.password,
            password_confirmation: this.password_confirmation
          })
        });
        if (response.ok) {
          alert('Mot de passe réinitialisé avec succès.');
          this.$router.push({ name: 'Login' });
        } else {
          const data = await response.json();
          alert(`Erreur : ${data.message || 'Erreur lors de la réinitialisation du mot de passe.'}`);
        }
      } catch (error) {
        console.error('Error :', error);
        alert('Erreur lors de la réinitialisation du mot de passe.');
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
