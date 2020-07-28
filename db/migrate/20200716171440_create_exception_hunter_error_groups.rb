class CreateExceptionHunterErrorGroups < ActiveRecord::Migration[6.0]
  def change
    enable_extension :pg_trgm

    create_table :exception_hunter_error_groups do |t|
      t.string :error_class_name, null: false
      t.string :message
      t.integer :status, default: 0
      t.text :tags, array: true, default: []

      t.timestamps

      t.index :message, opclass: :gin_trgm_ops, using: :gin
      t.index :status
    end
  end
end
