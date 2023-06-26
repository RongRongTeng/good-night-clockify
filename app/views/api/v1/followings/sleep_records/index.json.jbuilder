# frozen_string_literal: true

json.array! @sleep_records do |sleep_record|
  json.extract! sleep_record, :id, :user_id, :clocked_in, :clocked_out, :duration_in_minutes, :created_at, :updated_at
end
