<script setup>
</script>

<template>
  <div class="app">
    <header class="header">
      <nav>
        <router-link to="/">Home</router-link>
        <router-link to="/favorites">Favorites</router-link>
      </nav>
    </header>
    <main>
      <router-view />
    </main>
  </div>
  
</template>

<style scoped>
.header {
  display: flex;
  justify-content: center;
  padding: 1rem;
  border-bottom: 1px solid #eee;
  margin-bottom: 1rem;
}
nav {
  display: flex;
  gap: 1rem;
}
a {
  text-decoration: none;
}
main {
  padding: 0 1rem 2rem;
}
</style>
