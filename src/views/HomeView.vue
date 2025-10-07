<template>
  <div class="container">
    <QuoteCard :quote="currentQuote" />
    <div class="buttons">
      <button @click="nextQuote">Next Quote</button>
      <button @click="addFavorite">❤️ Add to Favorites</button>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import quotes from '../data/quotes.json'
import QuoteCard from '../components/QuoteCard.vue'

const currentQuote = ref({ text: '', author: '' })

function pickRandom() {
  return quotes[Math.floor(Math.random() * quotes.length)]
}

function nextQuote() {
  currentQuote.value = pickRandom()
}

function loadFavorites() {
  try {
    return JSON.parse(localStorage.getItem('favorites') || '[]')
  } catch (e) {
    return []
  }
}

function addFavorite() {
  const favorites = loadFavorites()
  favorites.push(currentQuote.value)
  localStorage.setItem('favorites', JSON.stringify(favorites))
}

onMounted(() => {
  currentQuote.value = pickRandom()
})
</script>

<style scoped>
.container {
  max-width: 720px;
  margin: 0 auto;
  padding: 2rem 1rem;
}
.buttons {
  display: flex;
  gap: 0.75rem;
  justify-content: center;
  margin-top: 1rem;
}
button {
  padding: 0.6rem 1rem;
  border-radius: 8px;
  border: 1px solid #e5e7eb;
  cursor: pointer;
  background: white;
}
button:hover {
  background: #f9fafb;
}
</style>

