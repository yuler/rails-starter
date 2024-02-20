import { Controller } from '@hotwired/stimulus'

/**
 * @example
 * 
 * ```html
 * <button data-controller="copy-to-clipboard"
 *  data-action="copy-to-clipboard#copy" 
 *  data-copy-to-clipboard-success-class="bg-green-500"
 *  data-copy-to-clipboard-content-value="content"
 * >
 *  Copy Content
 * </button>
 * ```
 */
export default class extends Controller {
  static values = { content: String }
  static classes = ['success']

  async copy(event) {
    event.preventDefault()
    this.reset()
    try {
      await navigator.clipboard.writeText(this.contentValue)
      this.element.classList.add(this.successClass)
    } catch { }
  }

  reset() {
    this.element.classList.remove(this.successClass)
    this.#forceReflow()
  }

  #forceReflow() {
    this.element.offsetWidth
  }
}