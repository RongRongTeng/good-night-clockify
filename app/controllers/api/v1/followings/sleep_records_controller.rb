# frozen_string_literal: true

module Api
  module V1
    module Followings
      class SleepRecordsController < ApplicationController
        resource_description do
          resource_id 'Sleep_records of followings'
        end
        api :GET, '/v1/followings/sleep_records', 'List sleep records of followings'
        returns code: 200 do
          property :id, Integer, desc: 'The ID of the sleep record'
          property :user_id, Integer, desc: 'The ID of the user owning the sleep record'
          property :clocked_in, :iso8601_date_time, desc: 'The clocked in time of the sleep record'
          property :clocked_out, :iso8601_date_time, desc: 'The clocked out time of the sleep record', required: false
          property :duration_in_minutes, Integer, desc: 'The duration of sleep in minutes', required: false
          property :created_at, :iso8601_date_time, desc: 'The creation timestamp'
          property :updated_at, :iso8601_date_time, desc: 'The last update timestamp'
        end
        def index
          @sleep_records = SleepRecord.where(user: current_user.followings)
                                      .from_previous_week_to_now
                                      .order('duration_in_minutes DESC NULLS LAST')
                                      .order(:id)
                                      .page(params[:page])
                                      .per(params[:page_size])
        end
      end
    end
  end
end
