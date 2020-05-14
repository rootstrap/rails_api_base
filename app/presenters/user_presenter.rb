class UserPresenter < BasePresenter
  delegate_missing_to :user

  def initialize(user)
    @user = user
  end

  def full_name
    return user.username if user.first_name.blank?

    "#{user.first_name} #{user.last_name}"
  end

  private

  attr_reader :user
end
