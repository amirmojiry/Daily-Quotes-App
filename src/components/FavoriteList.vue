<template>
  <div class="favorites">
    <h2>Favorites</h2>
    <ul v-if="favorites.length">
      <li v-for="(item, idx) in favorites" :key="idx" class="favorite-item">
        <span class="text">“{{ item.text }}” — {{ item.author }}</span>
        <button class="remove" @click="$emit('remove', idx)">Remove</button>
      </li>
    </ul>
    <p v-else class="empty">No favorites yet.</p>
  </div>
</template>

<script setup>
import { defineProps } from 'vue'

defineProps({
  favorites: {
    type: Array,
    required: true
  }
})
</script>

<style scoped>
.favorites {
  margin-top: 2rem;
}
ul {
  list-style: none;
  padding: 0;
}
.favorite-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0.75rem 0;
  border-bottom: 1px solid #eee;
}
.text {
  margin-right: 1rem;
}
.remove {
  background: #ef4444;
  color: white;
  border: none;
  padding: 0.4rem 0.75rem;
  border-radius: 6px;
  cursor: pointer;
}
.empty {
  color: #666;
}
</style>

