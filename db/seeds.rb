if Rails.env.development?
  AdminUser.where(email: 'admin@example.com')
           .first_or_create!(email: 'admin@example.com', password: 'password')
end

Setting.where(key: 'min_version').first_or_create!(key: 'min_version', value: '0.0')
