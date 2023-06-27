# frozen_string_literal: true

json.array! @sleep_records do |sleep_record|
  json.id sleep_record.id
  json.user do
    json.extract! sleep_record.user, :id, :name
  end
  json.extract! sleep_record, :clocked_in, :clocked_out, :duration_in_minutes, :created_at, :updated_at
end
