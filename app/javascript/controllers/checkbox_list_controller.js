import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  checkAll() {
    this.setAllCheckboxes(true)
  }

  checkNone() {
    this.setAllCheckboxes(false)
  }

  // private

  setAllCheckboxes(value) {
    this.checkboxes.forEach(el => {
      const checkbox = el

      if (!checkbox.disabled) {
        checkbox.checked = true
      }
    })
  }

  get checkboxes() {
    return this.element.querySelectorAll('input[type=checkbox]')
  }
}