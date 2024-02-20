import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['name', 'output']

  input() {
    this.outputTarget.textContent = this.nameTarget.value
  }
  // connect() {
  //   this.element.textContent = "Hello World!"
  // }
}
