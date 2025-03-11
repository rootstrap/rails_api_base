# frozen_string_literal: true

class CreateDummyTable < ActiveRecord::Migration[8.0]
  def change
    create_table :dummy_tables do |t|
      t.string :dummy

      t.timestamps
    end
  end
end
