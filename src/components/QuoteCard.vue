<template>
  <div class="quote-card">
    <p class="quote-text">“{{ quote.text }}”</p>
    <p class="quote-author">— {{ quote.author }}</p>
  </div>
  
</template>

<script setup>
import { defineProps } from 'vue'

defineProps({
  quote: {
    type: Object,
    required: true
  }
})
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
  font-size: 1.4rem;
  line-height: 1.6;
  margin: 0 0 1rem;
  font-weight: 400;
  font-style: italic;
}

.quote-author {
  font-size: 1rem;
  color: var(--text-color);
  opacity: 0.8;
  font-weight: 500;
}

@media (max-width: 768px) {
  .quote-card {
    padding: 1.5rem;
  }
  
  .quote-text {
    font-size: 1.2rem;
  }
  
  .quote-author {
    font-size: 0.9rem;
  }
}
</style>

