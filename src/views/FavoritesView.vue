<template>
  <div class="container">
    <FavoriteList :favorites="favorites" @remove="removeAt" />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import FavoriteList from '../components/FavoriteList.vue'

const favorites = ref([])

function loadFavorites() {
  try {
    return JSON.parse(localStorage.getItem('favorites') || '[]')
  } catch (e) {
    return []
  }
}

function removeAt(index) {
  favorites.value.splice(index, 1)
  localStorage.setItem('favorites', JSON.stringify(favorites.value))
}

onMounted(() => {
  favorites.value = loadFavorites()
})
</script>

<style scoped>
.container {
  max-width: 720px;
  margin: 0 auto;
  padding: 2rem 1rem;
}
</style>

