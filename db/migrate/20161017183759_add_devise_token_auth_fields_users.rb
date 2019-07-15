class AddDeviseTokenAuthFieldsUsers < ActiveRecord::Migration[5.0]
  def change
    change_table :users, bulk: true do |t|
      t.string :provider, null: false, default: 'email'
      t.string :uid, null: false, default: ''
      t.json :tokens

      t.index %i[uid provider], unique: true
    end
  end
end
