import { Controller } from '@hotwired/stimulus'

/**
 * @example
 * 
 * ```html
 * <a data-controller="anchor" data-action="anchor#scroll" href="#top">Back to Top</a>
 * ```
 */
export default class extends Controller {
  scroll(event) {
    event.preventDefault();
    const id = event.currentTarget.hash.replace(/^#/, "");
    const anchor = document.getElementById(id);
    anchor.scrollIntoView();
    anchor.focus();
  }
}
