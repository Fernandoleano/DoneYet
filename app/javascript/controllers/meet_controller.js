import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["captureArea", "previewArea", "dateInput", "titleInput", "headerTitle", "statusBadge"]

  connect() {
    console.log("Live Meeting Mode: Active")
  }

  // Quick Date Chips
  setToday(e) {
    e.preventDefault()
    this.setDate(0)
    this.highlightChip(e.target)
  }

  setTomorrow(e) {
    e.preventDefault()
    this.setDate(1)
    this.highlightChip(e.target)
  }

  setFriday(e) {
    e.preventDefault()
    // Simple logic: Find next Friday
    const today = new Date()
    const dayOfWeek = today.getDay()
    const daysUntilFriday = (5 - dayOfWeek + 7) % 7 || 7
    this.setDate(daysUntilFriday)
    this.highlightChip(e.target)
  }

  setDate(daysToAdd) {
    const date = new Date()
    date.setDate(date.getDate() + daysToAdd)
    const formatted = date.toISOString().slice(0, 16) // YYYY-MM-DDTHH:MM
    this.dateInputTarget.value = formatted
    this.titleInputTarget.focus()
  }

  highlightChip(clickedChip) {
    // Reset all chips visual state (optional, relying on hover/active css mostly)
  }

  // State Transitions
  endMeeting(e) {
    e.preventDefault()
    this.captureAreaTarget.classList.add("hidden")
    this.previewAreaTarget.classList.remove("hidden")
    this.headerTitleTarget.innerText = "Review Orders"
    this.statusBadgeTarget.innerText = "PREVIEW"
    this.statusBadgeTarget.classList.remove("bg-indigo-500/20", "text-indigo-300")
    this.statusBadgeTarget.classList.add("bg-amber-500/20", "text-amber-300")
  }

  resumeMeeting(e) {
    e.preventDefault()
    this.captureAreaTarget.classList.remove("hidden")
    this.previewAreaTarget.classList.add("hidden")
    this.headerTitleTarget.innerText = "Briefing Room"
    this.statusBadgeTarget.innerText = "LIVE"
    this.statusBadgeTarget.classList.add("bg-indigo-500/20", "text-indigo-300")
    this.statusBadgeTarget.classList.remove("bg-amber-500/20", "text-amber-300")
    this.titleInputTarget.focus()
  }
}
