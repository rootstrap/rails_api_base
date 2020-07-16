class CreateExceptionHunterErrors < ActiveRecord::Migration[6.0]
  def change
    create_table :exception_hunter_errors do |t|
      t.string :class_name, null: false
      t.string :message
      t.timestamp :occurred_at, null: false
      t.json :environment_data
      t.json :custom_data
      t.json :user_data
      t.string :backtrace, array: true, default: []

      t.belongs_to :error_group,
                   index: true,
                   foreign_key: { to_table: :exception_hunter_error_groups }

      t.timestamps
    end
  end
end
