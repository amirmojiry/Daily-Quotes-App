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
  padding: 1.5rem;
  border-radius: 8px;
  background: var(--card-bg, #f5f5f5);
  color: #222;
  box-shadow: 0 2px 12px rgba(0,0,0,0.08);
  text-align: center;
}
.quote-text {
  font-size: 1.25rem;
  line-height: 1.6;
  margin: 0 0 0.75rem;
}
.quote-author {
  font-size: 0.95rem;
  color: #666;
}
</style>

