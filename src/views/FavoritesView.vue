<template>
  <div class="container">
    <div class="favorites-header">
      <h1>My Favorite Quotes</h1>
      <p v-if="favorites.length > 0" class="count">
        {{ favorites.length }} quote{{ favorites.length !== 1 ? 's' : '' }} saved
      </p>
    </div>
    
    <div v-if="favorites.length === 0" class="empty-state">
      <div class="empty-icon">💭</div>
      <h2>No favorites yet</h2>
      <p>Start adding quotes to your favorites to see them here!</p>
    </div>
    
    <div v-else>
      <!-- Top pagination controls -->
      <div v-if="totalPages > 1" class="pagination top-pagination">
        <button 
          @click="currentPage--" 
          :disabled="currentPage === 1"
          class="page-btn"
        >
          ← Previous
        </button>
        
        <span class="page-info">
          Page {{ currentPage }} of {{ totalPages }}
        </span>
        
        <button 
          @click="currentPage++" 
          :disabled="currentPage === totalPages"
          class="page-btn"
        >
          Next →
        </button>
      </div>
      
      <!-- Paginated favorites list -->
      <div class="favorites-list">
        <div 
          v-for="(item, idx) in paginatedFavorites" 
          :key="idx" 
          class="favorite-item"
        >
          <div class="quote-content">
            <p class="quote-text">"{{ item.text }}"</p>
            <p class="quote-author">— {{ item.author }}</p>
          </div>
          <button class="remove-btn" @click="removeFavorite(item)">
            🗑️
          </button>
        </div>
      </div>
      
      <!-- Pagination controls -->
      <div v-if="totalPages > 1" class="pagination bottom-pagination">
        <button 
          @click="currentPage--" 
          :disabled="currentPage === 1"
          class="page-btn"
        >
          ← Previous
        </button>
        
        <span class="page-info">
          Page {{ currentPage }} of {{ totalPages }}
        </span>
        
        <button 
          @click="currentPage++" 
          :disabled="currentPage === totalPages"
          class="page-btn"
        >
          Next →
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'

const favorites = ref([])
const currentPage = ref(1)
const itemsPerPage = 10

function loadFavorites() {
  try {
    return JSON.parse(localStorage.getItem('favorites') || '[]')
  } catch (e) {
    return []
  }
}

function removeFavorite(quoteToRemove) {
  const index = favorites.value.findIndex(fav => {
    // Check both by ID (if available) and by text+author for backward compatibility
    if (fav.id && quoteToRemove.id) {
      return fav.id === quoteToRemove.id
    }
    return fav.text === quoteToRemove.text && fav.author === quoteToRemove.author
  })
  if (index !== -1) {
    favorites.value.splice(index, 1)
    localStorage.setItem('favorites', JSON.stringify(favorites.value))
    
    // Adjust current page if needed
    const newTotalPages = Math.ceil(favorites.value.length / itemsPerPage)
    if (currentPage.value > newTotalPages && newTotalPages > 0) {
      currentPage.value = newTotalPages
    }
  }
}

const totalPages = computed(() => {
  return Math.ceil(favorites.value.length / itemsPerPage)
})

const paginatedFavorites = computed(() => {
  const start = (currentPage.value - 1) * itemsPerPage
  const end = start + itemsPerPage
  return favorites.value.slice(start, end)
})

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

.favorites-header {
  text-align: center;
  margin-bottom: 2rem;
}

.favorites-header h1 {
  color: var(--text-color);
  margin-bottom: 0.5rem;
  font-size: 2rem;
}

.count {
  color: var(--text-color);
  opacity: 0.7;
  font-size: 1rem;
}

.empty-state {
  text-align: center;
  padding: 3rem 1rem;
  color: var(--text-color);
}

.empty-icon {
  font-size: 4rem;
  margin-bottom: 1rem;
}

.empty-state h2 {
  margin-bottom: 0.5rem;
  color: var(--text-color);
}

.empty-state p {
  opacity: 0.7;
  font-size: 1.1rem;
}

.favorites-list {
  margin-bottom: 2rem;
}

.favorite-item {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  padding: 1.5rem;
  margin-bottom: 1rem;
  background: var(--card-bg);
  border-radius: 12px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  transition: all 0.2s ease;
}

.favorite-item:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.15);
}

.quote-content {
  flex: 1;
  margin-right: 1rem;
}

.quote-text {
  font-size: 1.1rem;
  line-height: 1.5;
  margin: 0 0 0.5rem;
  color: var(--text-color);
  font-style: italic;
}

.quote-author {
  font-size: 0.9rem;
  color: var(--text-color);
  opacity: 0.8;
  margin: 0;
}

.remove-btn {
  background: #ef4444;
  color: white;
  border: none;
  padding: 0.5rem;
  border-radius: 8px;
  cursor: pointer;
  font-size: 1rem;
  transition: all 0.2s ease;
  min-width: 40px;
  height: 40px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.remove-btn:hover {
  background: #dc2626;
  transform: scale(1.05);
}

.pagination {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 1rem;
  padding: 1rem;
  background: var(--card-bg);
  border-radius: 12px;
}

.top-pagination {
  margin-bottom: 2rem;
}

.bottom-pagination {
  margin-top: 2rem;
}

.page-btn {
  padding: 0.5rem 1rem;
  border: 1px solid var(--button-border);
  background: var(--button-bg);
  color: var(--button-text);
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.2s ease;
}

.page-btn:hover:not(:disabled) {
  opacity: 0.8;
  transform: translateY(-1px);
}

.page-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
  transform: none;
}

.page-info {
  color: var(--text-color);
  font-weight: 500;
  padding: 0 1rem;
}

@media (max-width: 768px) {
  .favorite-item {
    flex-direction: column;
    align-items: stretch;
  }
  
  .quote-content {
    margin-right: 0;
    margin-bottom: 1rem;
  }
  
  .remove-btn {
    align-self: flex-end;
  }
  
  .pagination {
    flex-direction: column;
    gap: 0.5rem;
  }
  
  .page-info {
    order: -1;
  }
}
</style>

