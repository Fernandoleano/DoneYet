import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["window", "input", "messages", "trigger"]
  static values = { userName: String, userAvatar: String }

  connect() {
    this.isOpen = false
  }

  toggle(event) {
    if (event) event.preventDefault()
    this.isOpen = !this.isOpen
    
    if (this.isOpen) {
      this.windowTarget.classList.remove("translate-x-full")
      
      // Animate icon active state
      this.triggerTarget.classList.add("text-green-400", "bg-gray-800")
      this.triggerTarget.classList.remove("text-gray-400")
      
      setTimeout(() => this.inputTarget.focus(), 300)
    } else {
      this.close()
    }
  }

  close(event) {
    if (event) event.preventDefault()
    this.isOpen = false
    this.windowTarget.classList.add("translate-x-full")
    
    this.triggerTarget.classList.remove("text-green-400", "bg-gray-800")
    this.triggerTarget.classList.add("text-gray-400")
  }

  async send(event) {
    event.preventDefault()
    const query = this.inputTarget.value.trim()
    if (!query) return

    // Add user message
    this.addMessage(query, "user")
    this.inputTarget.value = ""
    this.inputTarget.disabled = true

    try {
      const response = await fetch("/ai_chat/query", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
        },
        body: JSON.stringify({ 
          query,
          context: {
            url: window.location.href,
            page_title: document.title
          }
        })
      })

      const data = await response.json()
      
      if (data.status === "success") {
        this.addMessage(data.message, "ai")
        // Emit event for real-time updates if needed
      } else {
        this.addMessage("System_Error: " + data.message, "error")
      }
    } catch (error) {
      this.addMessage("Network_Failure: Connection lost.", "error")
      console.error(error)
    } finally {
      this.inputTarget.disabled = false
      this.inputTarget.focus()
    }
  }

  addMessage(text, type) {
    const container = document.createElement("div")
    container.className = "flex flex-col gap-1 text-xs"
    
    const label = document.createElement("div")
    label.className = "flex items-center gap-2 mb-1 justify-end"
    
    if (type === "user") {
      // User Header
      const nameSpan = document.createElement("span")
      nameSpan.className = "text-blue-400 font-bold uppercase text-xs"
      nameSpan.textContent = this.userNameValue || "OPERATIVE"
      
      const avatarDiv = document.createElement("div")
      avatarDiv.className = "h-6 w-6 rounded-full bg-indigo-600 flex items-center justify-center overflow-hidden border border-blue-500/50"
      
      if (this.userAvatarValue) {
        const img = document.createElement("img")
        img.src = this.userAvatarValue
        img.className = "h-full w-full object-cover"
        avatarDiv.appendChild(img)
      } else {
        avatarDiv.textContent = (this.userNameValue || "?").charAt(0).toUpperCase()
        avatarDiv.className += " text-xs font-bold text-white relative top-[1px]"
      }
      
      label.appendChild(nameSpan)
      label.appendChild(avatarDiv)
    } else {
      // AI Header
      const aiLabel = document.createElement("span")
      aiLabel.className = "text-green-700 font-bold uppercase"
      aiLabel.textContent = "HQ Intel"
      label.className = "text-xs" 
      label.appendChild(aiLabel)
    }
    
    const bubble = document.createElement("div")
    
    // Spy Theme Styling
    if (type === "user") {
      bubble.className = "bg-blue-900/20 border border-blue-500/30 text-blue-300 p-3 rounded-tl-xl rounded-bl-xl rounded-br-xl ml-auto max-w-[85%]"
    } else if (type === "error") {
      bubble.className = "bg-red-900/20 border border-red-500/50 text-red-400 p-3"
    } else {
      bubble.className = "bg-gray-800 border border-green-900/30 text-green-400 p-3 rounded-br-xl rounded-bl-xl rounded-tr-xl max-w-[85%]"
    }
    
    bubble.innerText = text // Safe text node
    
    container.appendChild(label)
    container.appendChild(bubble)
    
    this.messagesTarget.appendChild(container)
    this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight
  }
}
