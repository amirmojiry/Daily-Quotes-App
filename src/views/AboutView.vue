<template>
  <div class="container">
    <div class="about-card">
      <h1>About Daily Quotes</h1>
      <div class="developer-info">
        <h2>👨‍💻 Amir Mojiri</h2>
        <p class="description">
          Hello! I'm Amir Mojiri, the developer behind this simple yet inspiring Daily Quotes app.
        </p>
        <p class="description">
          This app represents the beginning of my journey into mobile app development. 
          It's a simple, offline-first application designed to bring daily inspiration 
          and motivation to users' lives.
        </p>
        <p class="description">
          This is just the start! I'm working on building more apps with great features 
          and innovative solutions. Stay tuned for more exciting projects to come.
        </p>
      </div>
      
      <div class="app-info">
        <h3>📱 About This App</h3>
        <ul>
          <li>✨ 100% Offline - No internet required</li>
          <li>💾 Save your favorite quotes locally</li>
          <li>🌙 Dark/Light mode support</li>
          <li>📱 Mobile-optimized interface</li>
          <li>🚀 Built with Vue 3 + Capacitor</li>
        </ul>
      </div>
      
      <div class="version-info">
        <p>Version 1.0.1</p>
        <p>Built with ❤️ by Amir Mojiri</p>
      </div>
    </div>
  </div>
</template>

<script setup>
// No reactive data needed for this static page
</script>

<style scoped>
.container {
  max-width: 720px;
  margin: 0 auto;
  padding: 2rem 1rem;
}

.about-card {
  background: var(--card-bg);
  border-radius: 12px;
  padding: 2rem;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
  text-align: center;
}

h1 {
  color: var(--text-color);
  margin-bottom: 2rem;
  font-size: 2.5rem;
}

.developer-info {
  margin-bottom: 2rem;
}

h2 {
  color: var(--text-color);
  margin-bottom: 1rem;
  font-size: 1.8rem;
}

h3 {
  color: var(--text-color);
  margin-bottom: 1rem;
  font-size: 1.4rem;
}

.description {
  color: var(--text-color);
  line-height: 1.6;
  margin-bottom: 1rem;
  font-size: 1.1rem;
  opacity: 0.9;
}

.app-info {
  margin-bottom: 2rem;
  text-align: left;
}

.app-info ul {
  list-style: none;
  padding: 0;
}

.app-info li {
  color: var(--text-color);
  padding: 0.5rem 0;
  font-size: 1rem;
  opacity: 0.9;
}

.version-info {
  border-top: 1px solid var(--nav-border);
  padding-top: 1rem;
  margin-top: 2rem;
}

.version-info p {
  color: var(--text-color);
  margin: 0.5rem 0;
  opacity: 0.7;
  font-size: 0.9rem;
}

@media (max-width: 768px) {
  .about-card {
    padding: 1.5rem;
  }
  
  h1 {
    font-size: 2rem;
  }
  
  h2 {
    font-size: 1.5rem;
  }
}
</style>
