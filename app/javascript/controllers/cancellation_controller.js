import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "reason", "feedback"]

  openModal(event) {
    event.preventDefault()
    this.modalTarget.classList.remove("hidden")
    this.modalTarget.classList.add("flex")
  }

  closeModal(event) {
    if (event) event.preventDefault()
    this.modalTarget.classList.add("hidden")
    this.modalTarget.classList.remove("flex")
  }

  submitCancellation(event) {
    event.preventDefault()
    
    const reason = this.reasonTarget.value
    const feedback = this.feedbackTarget.value

    if (!reason) {
      alert("Please select a reason for canceling")
      return
    }

    // Submit the form with the cancellation data
    const form = document.createElement("form")
    form.method = "POST"
    form.action = "/subscriptions/cancel"
    
    const csrfToken = document.querySelector('meta[name="csrf-token"]').content
    const csrfInput = document.createElement("input")
    csrfInput.type = "hidden"
    csrfInput.name = "authenticity_token"
    csrfInput.value = csrfToken
    form.appendChild(csrfInput)

    const methodInput = document.createElement("input")
    methodInput.type = "hidden"
    methodInput.name = "_method"
    methodInput.value = "delete"
    form.appendChild(methodInput)

    const reasonInput = document.createElement("input")
    reasonInput.type = "hidden"
    reasonInput.name = "cancellation_reason"
    reasonInput.value = reason
    form.appendChild(reasonInput)

    const feedbackInput = document.createElement("input")
    feedbackInput.type = "hidden"
    feedbackInput.name = "cancellation_feedback"
    feedbackInput.value = feedback
    form.appendChild(feedbackInput)

    document.body.appendChild(form)
    form.submit()
  }
}
