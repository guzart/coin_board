import { ApplicationController } from "./application_controller";

const IDENTIFIER = "toggle-modal";

export const TOGGLE_MODAL_EVENT_NAME = "toggle-modal";

export class ToggleModalController extends ApplicationController {
  static identifier = IDENTIFIER;

  public static values = {
    selector: String,
  };
  declare readonly selectorValue: string;

  connect(): void {
    this.addActionDescriptors({ click: this.toggleModal.name });
  }

  toggleModal() {
    const modal = document.querySelector(this.selectorValue);
    if (modal instanceof HTMLElement) {
      modal.dispatchEvent(new CustomEvent(TOGGLE_MODAL_EVENT_NAME));
    }
  }
}
