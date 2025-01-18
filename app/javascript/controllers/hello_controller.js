import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.textContent = "Hello World!"
    const alert = document.querySelector("#alert")
  setTimeout(() => {
      if(alert) {
          alert.remove()
      }
  }, 3000)
  }
}
