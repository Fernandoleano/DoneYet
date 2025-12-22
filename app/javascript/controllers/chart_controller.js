import { Controller } from "@hotwired/stimulus"
import { Chart, registerables } from 'chart.js'

Chart.register(...registerables)

export default class extends Controller {
  static targets = ["canvas"]
  static values = {
    type: String,
    data: Object,
    options: Object
  }
  
  connect() {
    this.createChart()
  }
  
  disconnect() {
    if (this.chart) {
      this.chart.destroy()
    }
  }
  
  createChart() {
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
      scales: {
        y: {
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
