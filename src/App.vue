<script setup>
import { ref, onMounted } from 'vue'

const isDarkMode = ref(true)

function toggleTheme() {
  isDarkMode.value = !isDarkMode.value
  document.documentElement.setAttribute('data-theme', isDarkMode.value ? 'dark' : 'light')
  localStorage.setItem('theme', isDarkMode.value ? 'dark' : 'light')
}

onMounted(() => {
  const savedTheme = localStorage.getItem('theme') || 'dark'
  isDarkMode.value = savedTheme === 'dark'
  document.documentElement.setAttribute('data-theme', savedTheme)
})
</script>

<template>
  <div class="app">
    <header class="header">
      <nav>
        <router-link to="/">Home</router-link>
        <router-link to="/favorites">Favorites</router-link>
        <router-link to="/about">About</router-link>
      </nav>
      <button @click="toggleTheme" class="theme-toggle">
        {{ isDarkMode ? '☀️' : '🌙' }}
      </button>
    </header>
    <main>
      <router-view />
    </main>
  </div>
</template>

<style scoped>
.app {
  min-height: 100vh;
  background-color: var(--bg-color);
  color: var(--text-color);
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1rem;
  padding-top: max(1rem, env(safe-area-inset-top));
  border-bottom: 1px solid var(--nav-border);
  background-color: var(--nav-bg);
}

nav {
  display: flex;
  gap: 1rem;
}

nav a {
  text-decoration: none;
  color: var(--text-color);
  padding: 0.5rem 1rem;
  border-radius: 4px;
  transition: background-color 0.2s ease;
}

nav a:hover {
  background-color: var(--button-bg);
}

nav a.router-link-active {
  background-color: var(--button-border);
  color: white;
}

.theme-toggle {
  background: none;
  border: 1px solid var(--button-border);
  padding: 0.5rem;
  border-radius: 50%;
  cursor: pointer;
  font-size: 1.2rem;
  width: 40px;
  height: 40px;
  display: flex;
  align-items: center;
  justify-content: center;
}

main {
  padding: 0 1rem 2rem;
  min-height: calc(100vh - 80px - env(safe-area-inset-top));
}
</style>
