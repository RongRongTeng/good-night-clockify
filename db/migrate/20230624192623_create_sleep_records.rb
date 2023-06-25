# frozen_string_literal: true

class CreateSleepRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :sleep_records do |t|
      t.references :user, null: false, foreign_key: true
      t.timestamp :clocked_in, null: false
      t.timestamp :clocked_out
      t.integer :duration_in_minutes

      t.timestamps
    end
  end
end
