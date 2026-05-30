import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    patientId: Number,
    odontogramId: Number,
    updateUrl: String
  }

  connect() {
    this.selectedState = "carious"
  }

  selectState(event) {
    const btn = event.currentTarget
    this.element.querySelectorAll(".state-btn").forEach(b => b.classList.remove("active"))
    btn.classList.add("active")
    this.selectedState = btn.dataset.state
  }

  toggleFace(event) {
    const path = event.currentTarget
    const toothNumber = path.dataset.tooth
    const face = path.dataset.face

    if (!toothNumber || !face) return

    const formData = new FormData()
    formData.append("tooth_number", toothNumber)
    formData.append("face", face)
    formData.append("state", this.selectedState)

    fetch(this.updateUrlValue, {
      method: "POST",
      headers: {
        "X-CSRF-Token": document.querySelector("[name='csrf-token']").content,
        "Accept": "application/json"
      },
      body: formData
    })
    .then(response => {
      if (response.ok) {
        window.location.reload()
      }
    })
    .catch(error => console.error("Error:", error))
  }
}
