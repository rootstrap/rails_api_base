class Color < ApplicationRecord
  belongs_to :user

  validates :color_code, presence: true
  validate :valid_color_code_format

  before_validation :normalize_color_code
  after_create :log_color_creation
  after_destroy :log_color_deletion

  private

  def valid_color_code_format
    return if color_code.blank?

    # Basic format validation
    unless color_code.match?(/\A#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})\z/)
      errors.add(:color_code, "must be a valid hex color code (e.g., #FF0000 or #F00)")
    end
  end

  def normalize_color_code
    return if color_code.blank?

    # Remove any whitespace
    self.color_code = color_code.strip

    # Convert to uppercase for consistency
    self.color_code = color_code.upcase

    # If it's a 3-digit hex, convert to 6-digit
    if color_code.match?(/\A#[A-Fa-f0-9]{3}\z/)
      self.color_code = color_code.gsub(/\A#([A-Fa-f0-9])([A-Fa-f0-9])([A-Fa-f0-9])\z/, '#\1\1\2\2\3\3')
    end
  end

  def log_color_creation
    Rails.logger.info("Color created: #{color_code} for user #{user_id}")
  end

  def log_color_deletion
    Rails.logger.info("Color deleted: #{color_code} for user #{user_id}")
  end
end
