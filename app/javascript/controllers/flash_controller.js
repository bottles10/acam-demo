import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const alert = document.querySelector("#alert")
    setTimeout(() => {
      if(alert) {
        alert.remove()
      }
    }, 5000)
  }
}
