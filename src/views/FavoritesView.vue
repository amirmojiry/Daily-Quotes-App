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
          <div class="quote-actions">
            <button class="action-btn copy-btn" @click="copyQuote(item)" title="Copy quote">
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <rect x="9" y="9" width="13" height="13" rx="2" ry="2"></rect>
                <path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"></path>
              </svg>
            </button>
            <button class="action-btn share-btn" @click="shareQuote(item)" title="Share quote">
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <circle cx="18" cy="5" r="3"></circle>
                <circle cx="6" cy="12" r="3"></circle>
                <circle cx="18" cy="19" r="3"></circle>
                <line x1="8.59" y1="13.51" x2="15.42" y2="17.49"></line>
                <line x1="15.41" y1="6.51" x2="8.59" y2="10.49"></line>
              </svg>
            </button>
            <button class="remove-btn" @click="removeFavorite(item)" title="Remove from favorites">
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <polyline points="3,6 5,6 21,6"></polyline>
                <path d="M19,6v14a2,2 0 0,1 -2,2H7a2,2 0 0,1 -2,-2V6m3,0V4a2,2 0 0,1 2,-2h4a2,2 0 0,1 2,2v2"></path>
                <line x1="10" y1="11" x2="10" y2="17"></line>
                <line x1="14" y1="11" x2="14" y2="17"></line>
              </svg>
            </button>
          </div>
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

function copyQuote(quote) {
  const quoteText = `"${quote.text}" — ${quote.author}`
  
  if (navigator.clipboard && window.isSecureContext) {
    navigator.clipboard.writeText(quoteText).then(() => {
      showCopySuccess()
    }).catch(() => {
      fallbackCopy(quoteText)
    })
  } else {
    fallbackCopy(quoteText)
  }
}

function fallbackCopy(text) {
  const textArea = document.createElement('textarea')
  textArea.value = text
  textArea.style.position = 'fixed'
  textArea.style.left = '-999999px'
  textArea.style.top = '-999999px'
  document.body.appendChild(textArea)
  textArea.focus()
  textArea.select()
  
  try {
    document.execCommand('copy')
    showCopySuccess()
  } catch (err) {
    console.error('Failed to copy text: ', err)
  }
  
  document.body.removeChild(textArea)
}

function showCopySuccess() {
  // Create a temporary success message matching favorites message style
  const successMsg = document.createElement('div')
  successMsg.textContent = 'Quote copied to clipboard!'
  successMsg.style.cssText = `
    position: fixed;
    top: 20px;
    left: 50%;
    transform: translateX(-50%);
    background: #10b981;
    color: white;
    padding: 0.75rem 1rem;
    border-radius: 8px;
    border: 1px solid #059669;
    z-index: 1000;
    font-weight: 500;
    text-align: center;
    animation: slideIn 0.3s ease;
    max-width: 300px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  `
  
  // Add slideIn animation
  const style = document.createElement('style')
  style.textContent = `
    @keyframes slideIn {
      from {
        opacity: 0;
        transform: translateX(-50%) translateY(-10px);
      }
      to {
        opacity: 1;
        transform: translateX(-50%) translateY(0);
      }
    }
  `
  document.head.appendChild(style)
  
  document.body.appendChild(successMsg)
  
  setTimeout(() => {
    if (document.body.contains(successMsg)) {
      document.body.removeChild(successMsg)
    }
    if (document.head.contains(style)) {
      document.head.removeChild(style)
    }
  }, 3000)
}

async function shareQuote(quote) {
  const shareData = {
    title: 'Daily Quote',
    text: `"${quote.text}" — ${quote.author}`,
    url: window.location.href
  }
  
  if (navigator.share && navigator.canShare && navigator.canShare(shareData)) {
    try {
      await navigator.share(shareData)
    } catch (err) {
      if (err.name !== 'AbortError') {
        console.error('Error sharing:', err)
        fallbackShare(shareData.text)
      }
    }
  } else {
    fallbackShare(shareData.text)
  }
}

function fallbackShare(text) {
  // Create a share modal/dropdown
  const shareModal = document.createElement('div')
  shareModal.style.cssText = `
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, 0.5);
    z-index: 1000;
    display: flex;
    align-items: center;
    justify-content: center;
  `
  
  const shareBox = document.createElement('div')
  shareBox.style.cssText = `
    background: var(--card-bg);
    border-radius: 12px;
    padding: 2rem;
    max-width: 400px;
    width: 90%;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
  `
  
  shareBox.innerHTML = `
    <h3 style="margin: 0 0 1rem; color: var(--text-color);">Share Quote</h3>
    <p style="margin: 0 0 1.5rem; color: var(--text-color); opacity: 0.8; font-size: 0.9rem;">Choose how you'd like to share this quote:</p>
    <div style="display: flex; flex-direction: column; gap: 0.5rem;">
      <button class="share-option" data-action="copy" style="padding: 0.75rem; border: 1px solid var(--button-border); background: var(--button-bg); color: var(--button-text); border-radius: 8px; cursor: pointer; text-align: left;">
        📋 Copy to Clipboard
      </button>
      <button class="share-option" data-action="whatsapp" style="padding: 0.75rem; border: 1px solid var(--button-border); background: var(--button-bg); color: var(--button-text); border-radius: 8px; cursor: pointer; text-align: left;">
        💬 WhatsApp
      </button>
      <button class="share-option" data-action="twitter" style="padding: 0.75rem; border: 1px solid var(--button-border); background: var(--button-bg); color: var(--button-text); border-radius: 8px; cursor: pointer; text-align: left;">
        🐦 Twitter
      </button>
      <button class="share-option" data-action="facebook" style="padding: 0.75rem; border: 1px solid var(--button-border); background: var(--button-bg); color: var(--button-text); border-radius: 8px; cursor: pointer; text-align: left;">
        📘 Facebook
      </button>
      <button class="share-option" data-action="email" style="padding: 0.75rem; border: 1px solid var(--button-border); background: var(--button-bg); color: var(--button-text); border-radius: 8px; cursor: pointer; text-align: left;">
        📧 Email
      </button>
    </div>
    <button class="close-share" style="margin-top: 1rem; padding: 0.5rem 1rem; border: 1px solid var(--button-border); background: var(--button-bg); color: var(--button-text); border-radius: 8px; cursor: pointer; width: 100%;">
      Cancel
    </button>
  `
  
  shareModal.appendChild(shareBox)
  document.body.appendChild(shareModal)
  
  // Handle share options
  shareBox.addEventListener('click', (e) => {
    const action = e.target.dataset.action
    if (action) {
      handleShareAction(action, text)
      document.body.removeChild(shareModal)
    }
  })
  
  // Close modal
  shareBox.querySelector('.close-share').addEventListener('click', () => {
    document.body.removeChild(shareModal)
  })
  
  shareModal.addEventListener('click', (e) => {
    if (e.target === shareModal) {
      document.body.removeChild(shareModal)
    }
  })
}

function handleShareAction(action, text) {
  const encodedText = encodeURIComponent(text)
  const encodedUrl = encodeURIComponent(window.location.href)
  
  switch (action) {
    case 'copy':
      // Find the quote and copy it
      const tempQuote = { text: text.split('"')[1], author: text.split('— ')[1] }
      copyQuote(tempQuote)
      break
    case 'whatsapp':
      window.open(`https://wa.me/?text=${encodedText}`, '_blank')
      break
    case 'twitter':
      window.open(`https://twitter.com/intent/tweet?text=${encodedText}&url=${encodedUrl}`, '_blank')
      break
    case 'facebook':
      window.open(`https://www.facebook.com/sharer/sharer.php?u=${encodedUrl}&quote=${encodedText}`, '_blank')
      break
    case 'email':
      window.open(`mailto:?subject=Daily Quote&body=${encodedText}`, '_blank')
      break
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
  border-radius: 50%;
  cursor: pointer;
  transition: all 0.2s ease;
  width: 36px;
  height: 36px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.remove-btn:hover {
  background: #dc2626;
  transform: scale(1.05);
}

.quote-actions {
  display: flex;
  gap: 0.5rem;
  align-items: center;
  flex-direction: column;
}

.action-btn {
  background: var(--button-bg);
  color: var(--button-text);
  border: 1px solid var(--button-border);
  padding: 0.5rem;
  border-radius: 50%;
  cursor: pointer;
  transition: all 0.2s ease;
  width: 36px;
  height: 36px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.action-btn:hover {
  transform: scale(1.05);
}

.copy-btn:hover {
  background: #10b981;
  border-color: #059669;
  color: white;
}

.share-btn:hover {
  background: #3b82f6;
  border-color: #2563eb;
  color: white;
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
  
  .quote-actions {
    flex-direction: row;
    justify-content: flex-end;
    gap: 0.75rem;
  }
  
  .action-btn {
    width: 40px;
    height: 40px;
  }
  
  .remove-btn {
    width: 40px;
    height: 40px;
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

