module ConditionAttributes
  extend ActiveSupport::Concern

  included do
    cattr_accessor :condition_attributes_map, default: {}

    def condition_attribute(name)
      retriever = self.class.condition_attributes_map[name]
      retriever.is_a?(Proc) ? instance_exec(&retriever) : send(retriever)
    end
  end

  class_methods do
    def attribute_for_condition(name, retriever = nil)
      condition_attributes_map[name] = retriever || name
    end

    def condition_attributes
      condition_attributes_map.keys
    end
  end
end
