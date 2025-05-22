class CreateColors < ActiveRecord::Migration[8.0]
  def change
    create_table :colors do |t|
      t.references :user, null: false, foreign_key: true
      t.string :color_code

      t.timestamps
    end
  end
end
