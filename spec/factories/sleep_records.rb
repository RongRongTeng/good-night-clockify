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
FactoryBot.define do
  factory :sleep_record do
    user { association :user }
    clocked_in  { 8.hours.ago }
    clocked_out { DateTime.current }

    trait :clocked_in_only do
      clocked_in  { 8.hours.ago }
      clocked_out { nil }
    end
  end
end
