<template>
  <div class="container">
    <QuoteCard :quote="currentQuote" />
    <div class="buttons">
      <button @click="nextQuote" class="next-btn" title="Next Quote">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <polyline points="9,18 15,12 9,6"></polyline>
        </svg>
      </button>
      <button @click="addFavorite" class="favorite-btn" :disabled="isAlreadyFavorite" :title="isAlreadyFavorite ? 'Already Saved' : 'Add to Favorites'">
        <svg v-if="isAlreadyFavorite" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <polyline points="20,6 9,17 4,12"></polyline>
        </svg>
        <svg v-else width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path>
        </svg>
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
  
  // Add timestamp when adding to favorites
  const quoteWithTimestamp = {
    ...currentQuote.value,
    addedAt: Date.now()
  }
  
  favorites.push(quoteWithTimestamp)
  localStorage.setItem('favorites', JSON.stringify(favorites))
  showSuccessMessage('Quote added to favorites! ❤️')
}

function loadFontSize() {
  const saved = localStorage.getItem('fontSize')
  if (saved) {
    const fontSize = parseFloat(saved)
    document.documentElement.style.setProperty('--font-scale', fontSize)
  }
}

onMounted(() => {
  currentQuote.value = pickRandom()
  loadFontSize()
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
  padding: 0.75rem;
  border-radius: 50%;
  border: 1px solid var(--button-border);
  cursor: pointer;
  background: var(--button-bg);
  color: var(--button-text);
  transition: all 0.2s ease;
  width: 48px;
  height: 48px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.next-btn:hover {
  background: #8b5cf6;
  border-color: #7c3aed;
  color: white;
  transform: translateY(-1px);
}

.favorite-btn:hover {
  background: #ef4444;
  border-color: #dc2626;
  color: white;
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
    flex-direction: row;
    justify-content: center;
  }
  
  .next-btn, .favorite-btn {
    width: 52px;
    height: 52px;
  }
}
</style>

