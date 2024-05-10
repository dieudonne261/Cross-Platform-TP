<template>
    <div class="card ">
      <div class="card-body">
        <h5 class="card-title">{{ item.name }}</h5>
        <p class="card-text">Email: {{ item.email }}</p>
        <p class="card-text">Devise: {{ item.devise }}</p>
        <button class="btn" @click="handleUpdate">Mettre à jour</button>
        <button class="btn" @click="handleDelete">Supprimer</button>
      </div>
    </div>
</template>
  
<script>
    import "../public/bootstrap.min.js";
    export default {
        props: {
        item: {
            type: Object,
            required: true,
        },
        },
        methods: {
        handleUpdate() {
            this.$emit("update", this.item);
        },
        handleDelete() {
            this.$emit("delete", this.item.id);
        },
        },
    };
</script>
  
<style scoped>
    @import "../public/bootstrap.min.css";
    .btn{
        border-radius: 10px;
        margin: 5px;
        box-shadow: 0 0 20px rgba(29, 29, 29, 0.397);
    }
</style>