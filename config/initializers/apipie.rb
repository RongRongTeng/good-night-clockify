# frozen_string_literal: true

Apipie.configure do |config|
  config.app_name                = 'GoodNightClockify'
  config.api_base_url            = '/api'
  config.doc_base_url            = '/apipie'
  # where is your API defined?
  config.api_controllers_matcher = Rails.root.join('app/controllers/**/*.rb').to_s
end

module Apipie
  module Validator
    class ISO8601DateTimeValidator < BaseValidator
      def self.build(param_description, argument, _options, _block)
        new(param_description) if argument == :iso8601_date_time
      end

      def validate(value)
        return true if !param_description.options[:required] && value.nil?

        to_iso8601_dateime(value)

        true
      rescue StandardError
        false
      end

      def process_value(value)
        DateTime.iso8601(value)
      end

      def description
        'Must be a valid ISO 8601 datetime format'
      end

      private

      def to_iso8601_dateime(value)
        case value
        when Date
          value.to_datetime.iso8601
        when String
          DateTime.parse(value).iso8601
        else
          value.iso8601
        end
      end
    end
  end
end
