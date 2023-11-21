# frozen_string_literal: true

class ToggleComponent < ViewComponent::Base
  def initialize(label: "Label", label_position: :none, checked: false, disabled: false)
    @label = label
    @label_position = label_position
    @checked = checked
    @disabled = disabled
  end
end
