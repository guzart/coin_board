import { Application } from "@hotwired/stimulus";
import { CollapseController } from "./collapse_controller.ts";
import { ModalController } from "./modal_controller.ts";
import { ToggleModalController } from "./toggle_modal_controller.ts";

export function start() {
  const application = Application.start();

  // Configure Stimulus development experience
  application.debug = false;
  window.Stimulus = application;

  // Register controllers
  [CollapseController, ModalController, ToggleModalController].forEach(
    (controller) => application.register(controller.identifier, controller),
  );
}
