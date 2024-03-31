import { ApplicationController } from "./application_controller";

const IDENTIFIER = "message-condition-form";

const SENDER_ATTRIBUTE = "sender";
const EXACT_MATCHES_OPERATOR = "exactly_matches";

export class MessageConditionFormController extends ApplicationController {
  static identifier = IDENTIFIER;

  static targets = [
    "comparisonAttributeField",
    "comparisonOperatorField",
    "comparisonValueFieldGroup",
    "senderFieldGroup",
  ];
  declare readonly comparisonAttributeFieldTarget: HTMLSelectElement;
  declare readonly comparisonOperatorFieldTarget: HTMLSelectElement;
  declare readonly comparisonValueFieldGroupTarget: HTMLDivElement;
  declare readonly senderFieldGroupTarget: HTMLDivElement;

  connect() {
    this.addActionDescriptors({ input: this.updateFieldsVisibility });
    this.updateFieldsVisibility();
  }

  updateFieldsVisibility() {
    this.toggleComparisonValueFieldGroup();
    this.disableOperatorOptions();

    if (this.isSenderAttribute) {
      this.selectExactMatchOperator();
    }
  }

  private get isSenderAttribute() {
    return this.comparisonAttributeFieldTarget.value === SENDER_ATTRIBUTE;
  }

  private selectExactMatchOperator() {
    this.comparisonOperatorFieldTarget.value = EXACT_MATCHES_OPERATOR;
  }

  private toggleComparisonValueFieldGroup() {
    const isSenderAttribute = this.isSenderAttribute;

    this.senderFieldGroupTarget.classList.toggle(
      this.hideClass,
      !isSenderAttribute,
    );

    this.comparisonValueFieldGroupTarget.classList.toggle(
      this.hideClass,
      isSenderAttribute,
    );
  }

  private disableOperatorOptions() {
    Array.from(this.comparisonOperatorFieldTarget.options).forEach((option) => {
      option.disabled =
        this.isSenderAttribute && option.value !== EXACT_MATCHES_OPERATOR;
    });
  }
}
