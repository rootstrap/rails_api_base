class AddMustUpdateFields < ActiveRecord::Migration[6.0]
  def change
    create_table :settings do |t|
      t.string :key, null: false
      t.string :value
    end
  end
end
