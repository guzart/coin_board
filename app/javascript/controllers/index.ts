import { Application } from "@hotwired/stimulus";
import { CollapseController } from "./collapse_controller.ts";

export function start() {
  const application = Application.start();

  // Configure Stimulus development experience
  application.debug = false;
  window.Stimulus = application;

  // Register controllers
  [CollapseController].forEach((controller) =>
    application.register(controller.identifier, controller),
  );
}
