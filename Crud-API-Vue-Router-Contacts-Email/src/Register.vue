<template>
    <div class="container mt-5 text-center rounded-4 p-5 shadow">
      <h2>Mes contacts</h2>
    <h2 class="mb-5">Register</h2>
    <form @submit.prevent="register">
      <div class="mb-3">
        <input type="text" placeholder="Nom complet" class="form-control" id="name" v-model="name" required>
      </div>
      <div class="mb-3">
        <input type="email" placeholder="Email" class="form-control" id="email" v-model="email" required>
      </div>
      <div class="mb-3">
        <input type="password" placeholder="Mot de passe" class="form-control" id="password" v-model="password" required>
      </div>
      <div class="mb-3">
        <input type="password" placeholder="Confirmation" class="form-control" id="password_confirmation" v-model="password_confirmation" required>
      </div>
      <button type="submit" class="btn btn-primary w-100">Register</button>
      <div class="col-lg-12 text-center mt-5">
        Déja avoir un compte?
        <router-link to="/" class="btn-link">Login</router-link>
      </div>
    </form>
  
  </div>
</template>

<script>
export default {
  name: 'Register',
  data() {
    return {
      name: '',
      email: '',
      password: '',
      password_confirmation: ''
    };
  },
  mounted() {
    const token = localStorage.getItem('token');
    if (token) {
      this.$router.push({ name: 'Home' });
    }
  },
  methods: {
    async register() {
      try {
        const response = await fetch('http://127.0.0.1:8000/api/register', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json'
          },
          body: JSON.stringify({
            name: this.name,
            email: this.email,
            password: this.password,
            password_confirmation: this.password_confirmation
          })
        });
        alert('Inscription reussite.');
        this.$router.push({ name: 'Login' });
      } catch (error) {
        console.error('Error :', error);
        alert('Erreur lors de l`inscription');
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
