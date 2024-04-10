declare module "@hotwired/turbo-rails" {
  export const Turbo: {
    start: () => void;
  };
}

declare interface Window {
  Stimulus: unknown;
}
