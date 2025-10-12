<template>
  <div class="container">
    <div class="settings-header">
      <h1>Settings</h1>
      <p class="subtitle">Customize your Daily Quotes experience</p>
    </div>
    
    <div class="settings-card">
      <div class="setting-section">
        <h3>Display</h3>
        
        <div class="setting-item">
          <div class="setting-info">
            <h4>Theme</h4>
            <p class="setting-description">Switch between dark and light mode</p>
          </div>
          
          <div class="setting-controls">
            <button 
              @click="toggleTheme" 
              class="control-btn theme-toggle-btn"
              :title="isDarkMode ? 'Switch to light mode' : 'Switch to dark mode'"
            >
              <svg v-if="isDarkMode" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <circle cx="12" cy="12" r="5"></circle>
                <line x1="12" y1="1" x2="12" y2="3"></line>
                <line x1="12" y1="21" x2="12" y2="23"></line>
                <line x1="4.22" y1="4.22" x2="5.64" y2="5.64"></line>
                <line x1="18.36" y1="18.36" x2="19.78" y2="19.78"></line>
                <line x1="1" y1="12" x2="3" y2="12"></line>
                <line x1="21" y1="12" x2="23" y2="12"></line>
                <line x1="4.22" y1="19.78" x2="5.64" y2="18.36"></line>
                <line x1="18.36" y1="5.64" x2="19.78" y2="4.22"></line>
              </svg>
              <svg v-else width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"></path>
              </svg>
            </button>
          </div>
        </div>
        
        <div class="setting-item">
          <div class="setting-info">
            <h4>Font Size</h4>
            <p class="setting-description">Adjust the text size for better readability</p>
          </div>
          
          <div class="setting-controls">
            <button 
              @click="decreaseFontSize" 
              class="control-btn decrease-btn"
              :disabled="fontSize <= 0.8"
              title="Decrease font size"
            >
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <circle cx="12" cy="12" r="10"></circle>
                <line x1="8" y1="12" x2="16" y2="12"></line>
              </svg>
            </button>
            
            <span class="font-size-display">{{ Math.round(fontSize * 100) }}%</span>
            
            <button 
              @click="increaseFontSize" 
              class="control-btn increase-btn"
              :disabled="fontSize >= 1.5"
              title="Increase font size"
            >
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <circle cx="12" cy="12" r="10"></circle>
                <line x1="12" y1="8" x2="12" y2="16"></line>
                <line x1="8" y1="12" x2="16" y2="12"></line>
              </svg>
            </button>
          </div>
        </div>
        
        <div class="font-preview">
          <p class="preview-text">"{{ previewQuote.text }}"</p>
          <p class="preview-author">— {{ previewQuote.author }}</p>
        </div>
      </div>
    </div>
    
    <div class="settings-card">
      <div class="setting-section">
        <h3>Widget</h3>
        
        <div class="setting-item">
          <div class="setting-info">
            <h4>Home Screen Widget</h4>
            <p class="setting-description">Add inspirational quotes to your home screen</p>
          </div>
          
          <div class="setting-controls">
            <button 
              @click="updateWidget" 
              class="control-btn widget-btn"
              title="Update widget with current quote"
            >
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
                <polyline points="9,22 9,12 15,12 15,22"></polyline>
              </svg>
            </button>
          </div>
        </div>
        
        <div class="widget-info">
          <p class="widget-instructions">
            <strong>How to add widget:</strong><br>
            1. Long press on your home screen<br>
            2. Select "Widgets" or "Add Widget"<br>
            3. Find "Daily Quotes" in the list<br>
            4. Drag it to your desired location
          </p>
          <div v-if="widgetStatus" class="widget-status">
            <p class="status-text">{{ widgetStatus }}</p>
          </div>
        </div>
      </div>
    </div>
    
    <div class="settings-footer">
      <p class="version-info">Daily Quotes v{{ version }}</p>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import widgetService from '../services/widgetService.js'

const fontSize = ref(1.0)
const version = ref('1.0.4')
const isDarkMode = ref(true)
const widgetStatus = ref('')

const previewQuote = ref({
  text: "The only way to do great work is to love what you do.",
  author: "Steve Jobs"
})

function increaseFontSize() {
  if (fontSize.value < 1.5) {
    fontSize.value = Math.min(fontSize.value + 0.1, 1.5)
    saveFontSize()
    applyFontSize()
  }
}

function decreaseFontSize() {
  if (fontSize.value > 0.8) {
    fontSize.value = Math.max(fontSize.value - 0.1, 0.8)
    saveFontSize()
    applyFontSize()
  }
}

function saveFontSize() {
  localStorage.setItem('fontSize', fontSize.value.toString())
}

function loadFontSize() {
  const saved = localStorage.getItem('fontSize')
  if (saved) {
    fontSize.value = parseFloat(saved)
  }
}

function applyFontSize() {
  document.documentElement.style.setProperty('--font-scale', fontSize.value)
}

function toggleTheme() {
  isDarkMode.value = !isDarkMode.value
  document.documentElement.setAttribute('data-theme', isDarkMode.value ? 'dark' : 'light')
  localStorage.setItem('theme', isDarkMode.value ? 'dark' : 'light')
  // Update widget theme
  widgetService.updateWidgetTheme()
}

function loadTheme() {
  const savedTheme = localStorage.getItem('theme') || 'dark'
  isDarkMode.value = savedTheme === 'dark'
  document.documentElement.setAttribute('data-theme', savedTheme)
}

async function updateWidget() {
  try {
    await widgetService.updateWidget()
    widgetStatus.value = 'Widget updated successfully!'
    setTimeout(() => {
      widgetStatus.value = ''
    }, 3000)
  } catch (error) {
    widgetStatus.value = 'Widget update failed. Make sure the widget is installed.'
    setTimeout(() => {
      widgetStatus.value = ''
    }, 3000)
  }
}

onMounted(async () => {
  // Load saved theme
  loadTheme()
  
  // Load saved font size
  loadFontSize()
  applyFontSize()
  
  // Load version dynamically
  try {
    const packageInfo = await import('../../package.json')
    version.value = packageInfo.default.version
  } catch (error) {
    console.warn('Could not load version from package.json:', error)
  }
})
</script>

<style scoped>
.container {
  max-width: 720px;
  margin: 0 auto;
  padding: 2rem 1rem;
}

.settings-header {
  text-align: center;
  margin-bottom: 2rem;
}

.settings-header h1 {
  color: var(--text-color);
  margin-bottom: 0.5rem;
  font-size: 2rem;
}

.subtitle {
  color: var(--text-color);
  opacity: 0.7;
  font-size: 1rem;
}

.settings-card {
  background: var(--card-bg);
  border-radius: 12px;
  padding: 2rem;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
  margin-bottom: 2rem;
}

.setting-section h3 {
  color: var(--text-color);
  margin-bottom: 1.5rem;
  font-size: 1.4rem;
}

.setting-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1rem 0;
  border-bottom: 1px solid var(--nav-border);
}

.setting-item:last-child {
  border-bottom: none;
}

.setting-info {
  flex: 1;
}

.setting-info h4 {
  color: var(--text-color);
  margin: 0 0 0.5rem 0;
  font-size: 1.1rem;
}

.setting-description {
  color: var(--text-color);
  opacity: 0.7;
  margin: 0;
  font-size: 0.9rem;
}

.setting-controls {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.control-btn {
  padding: 0.75rem;
  border: 1px solid var(--button-border);
  background: var(--button-bg);
  color: var(--button-text);
  border-radius: 50%;
  cursor: pointer;
  transition: all 0.2s ease;
  width: 48px;
  height: 48px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.control-btn:hover:not(:disabled) {
  opacity: 0.8;
  transform: translateY(-1px);
}

.control-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
  transform: none;
}

.decrease-btn:hover:not(:disabled) {
  background: #ef4444;
  border-color: #dc2626;
  color: white;
}

.increase-btn:hover:not(:disabled) {
  background: #10b981;
  border-color: #059669;
  color: white;
}


.font-size-display {
  color: var(--text-color);
  font-weight: 600;
  font-size: 1rem;
  min-width: 60px;
  text-align: center;
}

.font-preview {
  margin-top: 1.5rem;
  padding: 1.5rem;
  background: var(--bg-color);
  border-radius: 8px;
  border: 1px solid var(--nav-border);
  text-align: center;
}

.preview-text {
  font-size: calc(1.4rem * var(--font-scale, 1));
  line-height: 1.6;
  margin: 0 0 1rem;
  font-weight: 400;
  font-style: italic;
  color: var(--text-color);
}

.preview-author {
  font-size: calc(1rem * var(--font-scale, 1));
  color: var(--text-color);
  opacity: 0.8;
  font-weight: 500;
  margin: 0;
}

.settings-footer {
  text-align: center;
  padding-top: 1rem;
  border-top: 1px solid var(--nav-border);
}

.version-info {
  color: var(--text-color);
  opacity: 0.6;
  font-size: 0.9rem;
  margin: 0;
}

.widget-info {
  margin-top: 1.5rem;
  padding: 1rem;
  background: var(--bg-color);
  border-radius: 8px;
  border: 1px solid var(--nav-border);
}

.widget-instructions {
  color: var(--text-color);
  font-size: 0.9rem;
  line-height: 1.5;
  margin: 0 0 1rem 0;
}

.widget-status {
  padding: 0.75rem;
  border-radius: 6px;
  background: #10b981;
  border: 1px solid #059669;
}

.status-text {
  color: white;
  font-size: 0.9rem;
  margin: 0;
  text-align: center;
  font-weight: 500;
}

.widget-btn:hover:not(:disabled) {
  background: #3b82f6;
  border-color: #2563eb;
  color: white;
}

@media (max-width: 768px) {
  .container {
    padding: 1.5rem 1rem;
  }
  
  .settings-card {
    padding: 1.5rem;
  }
  
  .settings-header h1 {
    font-size: 1.8rem;
  }
  
  .setting-item {
    flex-direction: column;
    align-items: stretch;
    gap: 1rem;
  }
  
  .setting-controls {
    justify-content: center;
  }
  
  .control-btn {
    width: 52px;
    height: 52px;
  }
}
</style>
