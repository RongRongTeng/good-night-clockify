# frozen_string_literal: true

class ValidateSleepRecordClockedInAndClockedOutSequenceConstraint < ActiveRecord::Migration[7.0]
  def change
    validate_check_constraint :sleep_records, name: 'sleep_records_clocked_in_and_clocked_out_sequence'
  end
end
