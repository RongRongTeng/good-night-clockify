# frozen_string_literal: true

class AddSleepRecordClockedInAndOutDurationNoOverlapWithinUserConstraint < ActiveRecord::Migration[7.0]
  def up
    execute <<~SQL.squish
      ALTER TABLE sleep_records
      ADD CONSTRAINT sleep_records_clocked_duration_no_overlap_within_user
      EXCLUDE USING gist (
        user_id WITH =,
        tsrange(clocked_in, COALESCE(clocked_out, clocked_in), '[]') WITH &&
      )
    SQL
  end

  def down
    execute <<~SQL.squish
      ALTER TABLE sleep_records
      DROP CONSTRAINT IF EXISTS sleep_records_clocked_duration_no_overlap_within_user
    SQL
  end
end
