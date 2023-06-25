# frozen_string_literal: true

class AddSleepRecordClockedInAndClockedOutSequenceConstraint < ActiveRecord::Migration[7.0]
  def change
    add_check_constraint :sleep_records, 'clocked_in < clocked_out',
                         name: 'sleep_records_clocked_in_and_clocked_out_sequence', validate: false
  end
end
