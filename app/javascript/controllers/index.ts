import { Application } from "@hotwired/stimulus";
import HelloController from "./hello_controller.ts";

export function start() {
  const application = Application.start();

  // Configure Stimulus development experience
  application.debug = false;
  window.Stimulus = application;

  // Register controllers
  application.register("hello", HelloController);
}
