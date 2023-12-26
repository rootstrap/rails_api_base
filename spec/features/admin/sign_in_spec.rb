# frozen_string_literal: true

RSpec.describe 'Admin SignIn' do
  feature 'Signing in', :js do
    let(:admin_user) { create(:admin_user) }

    scenario 'Admin signs in successfully' do
      visit admin_root_path
      fill_in 'Email', with: admin_user.email
      fill_in 'Password', with: admin_user.password
      click_button 'Login'

      expect(page).to have_content 'Signed in successfully.'
    end

    scenario 'Admin fails to sign in with invalid credentials' do
      visit admin_root_path
      fill_in 'Email', with: 'wrong@example.com'
      fill_in 'Password', with: 'wrongpassword'
      click_button 'Login'

      expect(page).to have_content 'Invalid Email or password.'
    end
  end
end
