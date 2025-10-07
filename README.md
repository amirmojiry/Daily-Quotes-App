# Daily Quotes App

## 🧠 Overview
Daily Quotes is a simple, offline-only mobile app built with **Vue 3 + Vite + Capacitor**.  
It displays a random inspirational quote every time the user opens the app or clicks the “Next Quote” button.  
Users can also **save their favorite quotes locally** (stored in `localStorage`) for later viewing.

This app **does not require any backend or server** — all quotes are stored within the app itself as static JSON data.  
It’s a perfect starter project to demonstrate hybrid app development using Vue and Capacitor.

---

## ✨ Features
- 📜 Random inspirational quote shown at startup
- 🔁 “Next Quote” button to load a new random quote
- ❤️ “Add to Favorites” button to save a quote locally
- ⭐ “Favorites” screen to see all saved quotes
- 🌙 Simple and clean UI (light & dark mode optional)
- 🚫 100% offline — no API or server calls required

---

## 🛠️ Tech Stack
- **Frontend:** Vue 3 (Composition API)
- **Build Tool:** Vite
- **Mobile Wrapper:** Capacitor (for Android/iOS builds)
- **Storage:** LocalStorage (browser API)
- **Styling:** Tailwind CSS (optional)

---

## 📁 Project Structure
```

daily-quotes/
├─ src/
│  ├─ assets/
│  ├─ components/
│  │  ├─ QuoteCard.vue
│  │  ├─ FavoriteList.vue
│  ├─ data/
│  │  └─ quotes.json
│  ├─ views/
│  │  ├─ HomeView.vue
│  │  ├─ FavoritesView.vue
│  ├─ App.vue
│  ├─ main.js
├─ capacitor.config.json
├─ package.json
└─ README.md

````

---

## ⚙️ Setup & Run (Web)
```bash
# Create project (if not already)
npm create vite@latest daily-quotes -- --template vue
cd daily-quotes

# Install dependencies
npm install

# Run for web preview
npm run dev
````

---

## 📱 Build for Mobile

### 1. Add Capacitor

```bash
npm install @capacitor/core @capacitor/cli
npx cap init
```

### 2. Add Platforms

```bash
npx cap add android
# or
npx cap add ios
```

### 3. Build and Sync

```bash
npm run build
npx cap copy
npx cap open android
# or
npx cap open ios
```

---

## 🧩 Core Logic

**quotes.json**

```json
[
  {"text": "The best way to get started is to quit talking and begin doing.", "author": "Walt Disney"},
  {"text": "Your time is limited, don't waste it living someone else's life.", "author": "Steve Jobs"},
  {"text": "The harder you work for something, the greater you'll feel when you achieve it.", "author": "Anonymous"}
]
```

**HomeView.vue (core idea)**

```vue
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
import quotes from '../data/quotes.json'
import { ref } from 'vue'

const currentQuote = ref(quotes[Math.floor(Math.random() * quotes.length)])
const favorites = ref(JSON.parse(localStorage.getItem('favorites') || '[]'))

function nextQuote() {
  currentQuote.value = quotes[Math.floor(Math.random() * quotes.length)]
}

function addFavorite() {
  favorites.value.push(currentQuote.value)
  localStorage.setItem('favorites', JSON.stringify(favorites.value))
}
</script>
```

---

## 🚀 Deployment

### For Android:

1. Open the Android project via Android Studio.
2. Build → Generate Signed Bundle / APK.
3. Upload to [Google Play Console](https://play.google.com/console).

### For iOS:

1. Open the iOS project via Xcode.
2. Configure signing and team.
3. Build → Archive → Distribute via App Store Connect.

---

## 🧾 License

MIT License – free to use, modify, and publish.

---

## 💡 Ideas for Extension

* Add daily notification to show a random quote.
* Allow users to add their own quotes.
* Add categories (motivation, love, humor, etc.).
* Share quotes to social media.
* Sync favorites with cloud storage (future feature).