import { Modal } from "bootstrap";
import { ApplicationController } from "./application_controller";
import { TOGGLE_MODAL_EVENT_NAME } from "./toggle_modal_controller";

const IDENTIFIER = "modal";

export class ModalController extends ApplicationController {
  static identifier = IDENTIFIER;

  private modal: Modal | undefined;

  connect() {
    this.modal = new Modal(this.element);
    this.addActionDescriptors({
      [TOGGLE_MODAL_EVENT_NAME]: this.toggleModal,
    });
  }

  disconnect(): void {
    this.modal?.dispose();
  }

  toggleModal(): void {
    this.modal?.toggle();
  }
}
