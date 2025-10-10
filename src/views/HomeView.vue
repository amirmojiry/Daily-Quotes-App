<template>
  <div class="container">
    <QuoteCard :quote="currentQuote" />
    <div class="buttons">
      <button @click="nextQuote" class="next-btn">Next Quote</button>
      <button @click="addFavorite" class="favorite-btn" :disabled="isAlreadyFavorite">
        {{ isAlreadyFavorite ? '✅ Already Saved' : '❤️ Add to Favorites' }}
      </button>
    </div>
    
    <!-- Success message -->
    <div v-if="showMessage" class="message success-message">
      {{ message }}
      <div v-if="message.includes('favorites')" class="message-link">
        <router-link to="/favorites">View your favorites →</router-link>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import quotes from '../data/quotes.json'
import QuoteCard from '../components/QuoteCard.vue'

const currentQuote = ref({ text: '', author: '' })
const showMessage = ref(false)
const message = ref('')

function pickRandom() {
  const randomQuote = quotes[Math.floor(Math.random() * quotes.length)]
  // Add a unique ID to help with duplicate detection
  return {
    ...randomQuote,
    id: `${randomQuote.text}-${randomQuote.author}`.replace(/[^a-zA-Z0-9]/g, '').toLowerCase()
  }
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

// Check if current quote is already in favorites
const isAlreadyFavorite = computed(() => {
  if (!currentQuote.value.text || !currentQuote.value.author) {
    return false
  }
  const favorites = loadFavorites()
  return favorites.some(fav => {
    // Check both by ID (if available) and by text+author for backward compatibility
    if (fav.id && currentQuote.value.id) {
      return fav.id === currentQuote.value.id
    }
    return fav.text === currentQuote.value.text && fav.author === currentQuote.value.author
  })
})

function showSuccessMessage(msg) {
  message.value = msg
  showMessage.value = true
  setTimeout(() => {
    showMessage.value = false
  }, 3000)
}

function addFavorite() {
  // Double-check for duplicates before adding
  const favorites = loadFavorites()
  const isDuplicate = favorites.some(fav => {
    // Check both by ID (if available) and by text+author for backward compatibility
    if (fav.id && currentQuote.value.id) {
      return fav.id === currentQuote.value.id
    }
    return fav.text === currentQuote.value.text && fav.author === currentQuote.value.author
  })
  
  if (isDuplicate) {
    showSuccessMessage('This quote is already in your favorites!')
    return
  }
  
  favorites.push(currentQuote.value)
  localStorage.setItem('favorites', JSON.stringify(favorites))
  showSuccessMessage('Quote added to favorites! ❤️')
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
  flex-wrap: wrap;
}

.next-btn, .favorite-btn {
  padding: 0.75rem 1.5rem;
  border-radius: 8px;
  border: 1px solid var(--button-border);
  cursor: pointer;
  background: var(--button-bg);
  color: var(--button-text);
  font-size: 1rem;
  font-weight: 500;
  transition: all 0.2s ease;
  min-width: 140px;
}

.next-btn:hover, .favorite-btn:hover {
  opacity: 0.8;
  transform: translateY(-1px);
}

.favorite-btn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
  transform: none;
}

.message {
  margin-top: 1rem;
  padding: 0.75rem 1rem;
  border-radius: 8px;
  text-align: center;
  font-weight: 500;
  animation: slideIn 0.3s ease;
}

.success-message {
  background: #10b981;
  color: white;
  border: 1px solid #059669;
}

.message-link {
  margin-top: 0.5rem;
}

.message-link a {
  color: white;
  text-decoration: underline;
  font-weight: 600;
  transition: opacity 0.2s ease;
}

.message-link a:hover {
  opacity: 0.8;
}

@keyframes slideIn {
  from {
    opacity: 0;
    transform: translateY(-10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@media (max-width: 768px) {
  .buttons {
    flex-direction: column;
    align-items: center;
  }
  
  .next-btn, .favorite-btn {
    width: 100%;
    max-width: 200px;
  }
}
</style>

