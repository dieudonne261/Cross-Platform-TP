<template>
  <div class="container mt-5 text-center rounded-4 p-5 shadow">
    <h2>Mes contacts</h2>
    <h2 class="mb-5">Login</h2>
    <form @submit.prevent="login">
      <div class="mb-3">
        <input type="email" placeholder="Email" class="form-control" id="email" v-model="email" required>
      </div>
      <div class="mb-3">
        <input type="password" placeholder="Mot de passe" class="form-control" id="password" v-model="password" required>
      </div>
      <button type="submit" class="btn btn-primary w-100">Se connecter</button>
      <div class="col-lg-12 text-center mt-5">
        Pas de compte?
        <router-link to="/register" class="btn-link">Créez</router-link>
      </div>
    </form>
  </div>
</template>

<script>
export default {
  name: 'Login',
  data() {
    return {
      email: '',
      password: ''
    };
  },
  mounted() {
    const token = localStorage.getItem('token');
    if (token) {
      this.$router.push({ name: 'Home' });
    }
  },
  methods: {
    async login() {
      try {
        const response = await fetch('http://127.0.0.1:8000/api/login', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json'
          },
          body: JSON.stringify({
            email: this.email,
            password: this.password
          })
        });
        const data = await response.json();
        localStorage.setItem('token', data.access_token);
        this.$router.push({ name: 'Home' });
      } catch (error) {
        console.error('Error :', error);
        alert('Email ou mots de passe incorrect');
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