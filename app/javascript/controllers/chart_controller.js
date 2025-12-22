import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["canvas"]
  static values = {
    type: String,
    data: Object,
    options: Object
  }
  
  connect() {
    // Wait for Chart.js to load from CDN
    if (typeof Chart !== 'undefined') {
      this.createChart()
    } else {
      setTimeout(() => this.createChart(), 100)
    }
  }
  
  disconnect() {
    if (this.chart) {
      this.chart.destroy()
    }
  }
  
  createChart() {
    if (!this.canvasTarget || typeof Chart === 'undefined') return
    
    const ctx = this.canvasTarget.getContext('2d')
    
    this.chart = new Chart(ctx, {
      type: this.typeValue,
      data: this.dataValue,
      options: {
        ...this.defaultOptions(),
        ...this.optionsValue
      }
    })
  }
  
  defaultOptions() {
    return {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: {
          labels: {
            color: '#9CA3AF',
            font: {
              family: 'Inter, system-ui, sans-serif'
            }
          }
        }
      },
      scales: this.typeValue === 'doughnut' ? {} : {
        y: {
          beginAtZero: true,
          ticks: {
            color: '#9CA3AF'
          },
          grid: {
            color: '#374151'
          }
        },
        x: {
          ticks: {
            color: '#9CA3AF'
          },
          grid: {
            color: '#374151'
          }
        }
      }
    }
  }
}
