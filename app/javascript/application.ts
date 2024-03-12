import { Turbo } from "@hotwired/turbo-rails";
import * as Controllers from "./controllers/index.ts";
// import * as bootstrap from "bootstrap";

Turbo.start();
Controllers.start();
