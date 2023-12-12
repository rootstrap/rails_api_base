import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['input', 'switch', 'handler'];

  connect() {
    this.updateState();
  }

  toggle() {
    this.inputTarget.checked = !this.inputTarget.checked;
    this.updateState();
  }

  updateState() {
    this.switchTarget.classList.toggle('bg-indigo-600', this.inputTarget.checked);
    this.switchTarget.classList.toggle('bg-gray-200', !this.inputTarget.checked);
    this.handlerTarget.classList.toggle('translate-x-5', this.inputTarget.checked);
    this.handlerTarget.classList.toggle('translate-x-0', !this.inputTarget.checked);
  }
}
