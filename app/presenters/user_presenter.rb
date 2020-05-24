class UserPresenter < BasePresenter
  def full_name
    return record.username if record.first_name.blank?

    "#{record.first_name} #{record.last_name}"
  end
end
