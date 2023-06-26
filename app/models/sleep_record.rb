# frozen_string_literal: true

# == Schema Information
#
# Table name: sleep_records
#
#  id                  :bigint           not null, primary key
#  user_id             :bigint           not null
#  clocked_in          :datetime         not null
#  clocked_out         :datetime
#  duration_in_minutes :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
class SleepRecord < ApplicationRecord
  belongs_to :user

  validates :clocked_in, presence: true
  validates :clocked_in, comparison: { less_than_or_equal_to: :current }, if: :clocked_out?
  validates :clocked_out, comparison: { greater_than: :clocked_in, less_than_or_equal_to: :current }, if: :clocked_out?
  validate  :validate_overlaps_with_others

  before_save :set_duration_in_minutes

  private

  def set_duration_in_minutes
    self.duration_in_minutes = ((clocked_out - clocked_in).seconds.in_minutes.round if clocked_out?)
  end

  def clocked_out?
    clocked_out.present?
  end

  def current
    DateTime.current
  end

  def overlapped_sleep_records
    overlapped_sleep_records = user.sleep_records
    overlapped_sleep_records = overlapped_sleep_records.where.not(id:) if persisted?
    overlapped_sleep_records.where(
      "TSRANGE(clocked_in, COALESCE(clocked_out, clocked_in), '[]') && " \
      "TSRANGE(?::timestamp, COALESCE(?, ?)::timestamp, '[]')",
      clocked_in, clocked_out, clocked_in
    )
  end

  def validate_overlaps_with_others
    return if clocked_out? && clocked_in > clocked_out # Avoid TSRANGE lower bound > upper bound

    overlapped_sleep_records.each do |overlapped_sleep_record|
      errors.add(:base, :overlaps_with_others, id: overlapped_sleep_record.id,
                                               clocked_in: overlapped_sleep_record.clocked_in,
                                               clocked_out: overlapped_sleep_record.clocked_out)
    end
  end
end
