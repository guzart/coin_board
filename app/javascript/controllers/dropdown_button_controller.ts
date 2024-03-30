import { Dropdown } from "bootstrap";
import { ApplicationController } from "./application_controller";

const IDENTIFIER = "dropdown-button";

export class DropdownButtonController extends ApplicationController {
  static identifier = IDENTIFIER;

  static targets = ["toggle"];
  declare readonly toggleTarget: HTMLElement;

  private dropdown: Dropdown | undefined;

  connect() {
    this.toggleTarget.setAttribute("data-bs-toggle", "dropdown");
    this.toggleTarget.setAttribute("aria-expanded", "false");
    this.dropdown = new Dropdown(this.toggleTarget);
  }

  disconnect(): void {
    this.dropdown?.dispose();
  }
}
