class CreateTargets < ActiveRecord::Migration[7.0]
  def change
    create_table :targets do |t|
      t.references :topic, null: false, foreign_key: true
      t.string :title
      t.string :radius
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
