# frozen_string_literal: true

module Api
  module V1
    module Followings
      class SleepRecordsController < ApplicationController
        include Apipie::SleepRecord

        resource_description do
          resource_id 'Sleep_records of followings'
        end
        api :GET, '/v1/followings/sleep_records', 'List sleep records of followings'
        returns code: 200 do
          param_group :sleep_record
          property :user, Hash, desc: 'Owner of the sleep record' do
            property :id, Integer, desc: 'The ID of the user'
            property :name, String, desc: 'The name of the user'
          end
        end
        def index
          @sleep_records = SleepRecord.includes(:user)
                                      .where(user: current_user.followings)
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
