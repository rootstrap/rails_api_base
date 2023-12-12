class Toggle::ComponentPreview < Lookbook::Preview
  # @param label text
  # @param label_position select { choices: [~, top, left, right] }
  # @param checked toggle
  # @param disabled toggle
  def standard(label: nil, label_position: nil, checked: false, disabled: false)
    render Toggle::Component.new(label: label, label_position: label_position, checked: checked, disabled: disabled)
  end
end
