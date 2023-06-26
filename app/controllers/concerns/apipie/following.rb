# frozen_string_literal: true

module Apipie
  module Following
    extend ActiveSupport::Concern

    included do
      def_param_group :following do
        property :id, Integer, desc: 'The ID of the following'
        property :user_id, Integer, desc: 'The ID of the following user'
        property :created_at, :iso8601_date_time, desc: 'The creation timestamp'
        property :updated_at, :iso8601_date_time, desc: 'The last update timestamp'
      end
    end
  end
end
