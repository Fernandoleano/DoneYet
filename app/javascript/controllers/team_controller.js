import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal"]

  showInviteModal() {
    this.modalTarget.classList.remove("hidden")
  }

  hideInviteModal() {
    this.modalTarget.classList.add("hidden")
  }
}
