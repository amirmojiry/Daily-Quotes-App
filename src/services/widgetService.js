// Widget Service for Daily Quotes App
// Manages widget data updates and communication

import quotes from '../data/quotes.json'

class WidgetService {
  constructor() {
    this.currentQuote = null
    this.isWidgetAvailable = false
    this.init()
  }

  async init() {
    try {
      // Check if widget plugin is available
      const { WidgetsBridgePlugin } = await import('capacitor-widgetsbridge-plugin')
      this.isWidgetAvailable = true
      console.log('Widget service initialized')
    } catch (error) {
      console.log('Widget plugin not available:', error.message)
      this.isWidgetAvailable = false
    }
  }

  // Pick a random quote
  pickRandomQuote() {
    const randomQuote = quotes[Math.floor(Math.random() * quotes.length)]
    return {
      text: randomQuote.text,
      author: randomQuote.author,
      timestamp: Date.now()
    }
  }

  // Update widget with new quote
  async updateWidget(quote = null) {
    if (!this.isWidgetAvailable) {
      console.log('Widget not available')
      return
    }

    try {
      const quoteToShare = quote || this.pickRandomQuote()
      this.currentQuote = quoteToShare

      const { WidgetsBridgePlugin } = await import('capacitor-widgetsbridge-plugin')
      
      const widgetData = {
        quote: quoteToShare.text,
        author: quoteToShare.author,
        timestamp: quoteToShare.timestamp,
        appName: 'Daily Quotes',
        theme: this.getCurrentTheme()
      }

      await WidgetsBridgePlugin.updateWidget({ 
        data: JSON.stringify(widgetData)
      })

      console.log('Widget updated with quote:', quoteToShare.text)
    } catch (error) {
      console.error('Failed to update widget:', error)
    }
  }

  // Get current theme for widget styling
  getCurrentTheme() {
    const savedTheme = localStorage.getItem('theme') || 'dark'
    return savedTheme
  }

  // Update widget when app theme changes
  async updateWidgetTheme() {
    if (this.currentQuote) {
      await this.updateWidget(this.currentQuote)
    }
  }

  // Update widget when font size changes
  async updateWidgetFontSize() {
    if (this.currentQuote) {
      await this.updateWidget(this.currentQuote)
    }
  }

  // Get widget data for debugging
  getWidgetData() {
    return {
      currentQuote: this.currentQuote,
      isAvailable: this.isWidgetAvailable,
      theme: this.getCurrentTheme()
    }
  }
}

// Export singleton instance
export default new WidgetService()
