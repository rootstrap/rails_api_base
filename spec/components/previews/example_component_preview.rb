class ExampleComponentPreview < Lookbook::Preview
  # @param title
  def standard(title: "Click me")
    render ExampleComponent.new(title: title)
  end
end
