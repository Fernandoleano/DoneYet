import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["text"]
  static values = { speed: { type: Number, default: 50 } }
  
  connect() {
    this.typeText()
  }
  
  typeText() {
    const fullText = this.textTarget.dataset.text
    this.textTarget.textContent = ""
    let index = 0
    
    const interval = setInterval(() => {
      if (index < fullText.length) {
        this.textTarget.textContent += fullText[index]
        index++
      } else {
        clearInterval(interval)
      }
    }, this.speedValue)
  }
}
