<template>
  <div class="quote-card">
    <p class="quote-text">"{{ quote.text }}"</p>
    <p class="quote-author">— {{ quote.author }}</p>
    
    <div class="quote-actions">
      <button @click="copyQuote" class="action-btn copy-btn" title="Copy quote">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <rect x="9" y="9" width="13" height="13" rx="2" ry="2"></rect>
          <path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"></path>
        </svg>
      </button>
      <button @click="shareQuote" class="action-btn share-btn" title="Share quote">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <circle cx="18" cy="5" r="3"></circle>
          <circle cx="6" cy="12" r="3"></circle>
          <circle cx="18" cy="19" r="3"></circle>
          <line x1="8.59" y1="13.51" x2="15.42" y2="17.49"></line>
          <line x1="15.41" y1="6.51" x2="8.59" y2="10.49"></line>
        </svg>
      </button>
    </div>
  </div>
</template>

<script setup>
import { defineProps } from 'vue'

const props = defineProps({
  quote: {
    type: Object,
    required: true
  }
})

function copyQuote() {
  const quoteText = `"${props.quote.text}" — ${props.quote.author}`
  
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

async function shareQuote() {
  const shareData = {
    title: 'Daily Quote',
    text: `"${props.quote.text}" — ${props.quote.author}`,
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
      copyQuote()
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
</script>

<style scoped>
.quote-card {
  padding: 2rem;
  border-radius: 12px;
  background: var(--card-bg);
  color: var(--text-color);
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
  text-align: center;
  margin-bottom: 1rem;
  transition: all 0.3s ease;
}

.quote-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 25px rgba(0, 0, 0, 0.15);
}

.quote-text {
  font-size: calc(1.4rem * var(--font-scale, 1));
  line-height: 1.6;
  margin: 0 0 1rem;
  font-weight: 400;
  font-style: italic;
}

.quote-author {
  font-size: calc(1rem * var(--font-scale, 1));
  color: var(--text-color);
  opacity: 0.8;
  font-weight: 500;
}

.quote-actions {
  display: flex;
  gap: 0.75rem;
  justify-content: center;
  margin-top: 1.5rem;
  flex-wrap: wrap;
}

.action-btn {
  padding: 0.75rem;
  border: 1px solid var(--button-border);
  background: var(--button-bg);
  color: var(--button-text);
  border-radius: 50%;
  cursor: pointer;
  transition: all 0.2s ease;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 44px;
  height: 44px;
}

.action-btn:hover {
  opacity: 0.8;
  transform: translateY(-1px);
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

@media (max-width: 768px) {
  .quote-card {
    padding: 1.5rem;
  }
  
  .quote-text {
    font-size: calc(1.2rem * var(--font-scale, 1));
  }
  
  .quote-author {
    font-size: calc(0.9rem * var(--font-scale, 1));
  }
  
  .quote-actions {
    flex-direction: row;
    justify-content: center;
  }
  
  .action-btn {
    width: 48px;
    height: 48px;
  }
}
</style>

