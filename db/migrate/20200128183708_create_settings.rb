class CreateSettings < ActiveRecord::Migration[6.0]
  def change
    create_table :settings do |t|
      t.string :key, null: false
      t.string :value

      t.timestamps

      t.index :key, unique: true
    end
  end
end
