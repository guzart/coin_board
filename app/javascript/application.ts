import { Turbo } from "@hotwired/turbo-rails";
import * as Controllers from "./controllers/index.ts";

Turbo.start();
Controllers.start();
