import { Controller } from "@hotwired/stimulus";
import { Collapse } from "bootstrap";

const IDENTIFIER = "collapse";

export class CollapseController extends Controller {
  static identifier = IDENTIFIER;

  private collapse: Collapse | undefined;

  connect() {
    const target = this.target;
    if (target) {
      this.collapse = new Collapse(this.target, { toggle: false });
    }
  }

  disconnect(): void {
    this.collapse?.dispose();
  }

  private get target(): HTMLElement | null {
    const target = this.element.getAttribute("data-bs-target");
    return target ? document.querySelector(target) : null;
  }
}
