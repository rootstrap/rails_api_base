module Base64Attach
  extend self

  def attachment_from_base64(data:, filename: Time.current.to_i.to_s)
    base64_image = data.sub(/^data:.*,/, '')

    decoded_image = Base64.decode64(base64_image)
    image_io = StringIO.new(decoded_image)

    { io: image_io, filename: filename }
  end
end
