import { Controller } from "@hotwired/stimulus";

export abstract class ApplicationController extends Controller {
  protected addActionDescriptors(actions: Record<string, Function>) {
    const existingActions = this.element.getAttribute("data-action") || "";
    const actionDescriptors = Object.entries(actions)
      .map(([name, handler]) => {
        return `${name}->${this.identifier}#${handler.name}`;
      })
      .filter((descriptor) => !existingActions.includes(descriptor))
      .join(" ");

    this.element.setAttribute(
      "data-action",
      `${existingActions} ${actionDescriptors}`,
    );
  }

  protected hideClass = "d-none";
}
