# frozen_string_literal: true

module Apipie
  module SleepRecord
    extend ActiveSupport::Concern

    included do
      def_param_group :sleep_record_param do
        param :sleep_record, Hash, required: true, action_aware: true do
          param :clocked_in, :iso8601_date_time, desc: 'The clocked in time of the sleep record', required: true
          param :clocked_out, :iso8601_date_time, desc: 'The clocked out time of the sleep record'
        end
      end

      def_param_group :sleep_record do
        property :id, Integer, desc: 'The ID of the sleep record'
        property :clocked_in, :iso8601_date_time, desc: 'The clocked in time of the sleep record'
        property :clocked_out, :iso8601_date_time, desc: 'The clocked out time of the sleep record', required: false
        property :duration_in_minutes, Integer, desc: 'The duration of sleep in minutes', required: false
        property :created_at, :iso8601_date_time, desc: 'The creation timestamp'
        property :updated_at, :iso8601_date_time, desc: 'The last update timestamp'
      end
    end
  end
end
