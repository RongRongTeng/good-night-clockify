# frozen_string_literal: true

module Api
  module V1
    class SleepRecordsController < ApplicationController
      include Apipie::SleepRecord

      before_action :set_sleep_record, only: %i[show update destroy]

      api :GET, '/v1/sleep_records', 'List sleep records'
      returns code: 200 do
        param_group :sleep_record
      end
      def index
        @sleep_records = current_user.sleep_records
                                     .order(created_at: :desc)
                                     .order(:id)
                                     .page(params[:page])
                                     .per(params[:page_size])
      end

      api :GET, '/v1/sleep_records/:id', 'Get a sleep record'
      param :id, :number, desc: 'The ID of the sleep record', required: true
      returns code: 200 do
        param_group :sleep_record
      end
      error code: 404, desc: 'Not found'
      def show; end

      api :POST, '/v1/sleep_records', 'Create a sleep record'
      param_group :sleep_record_param, as: :create
      returns code: 201 do
        param_group :sleep_record
      end
      error code: 404, desc: 'Not found'
      error code: 422, desc: 'Missing required parameter or invalid parameter'
      def create
        @sleep_record = current_user.sleep_records.create!(sleep_record_params)

        render :show, status: :created, locals: { sleep_record: @sleep_record }
      end

      api 'PATCH|PUT', '/v1/sleep_records/:id', 'Update a sleep record'
      param :id, :number, desc: 'The ID of the sleep record', required: true
      param_group :sleep_record_param
      returns code: 200 do
        param_group :sleep_record
      end
      error code: 404, desc: 'Not found'
      error code: 422, desc: 'Missing required parameter or invalid parameter'
      def update
        @sleep_record.update!(sleep_record_params)

        render :show, status: :ok, locals: { sleep_record: @sleep_record }
      end

      api :DELETE, '/v1/sleep_records/:id', 'Delete a sleep record'
      param :id, :number, desc: 'The ID of the sleep record', required: true
      returns code: 200 do
        param_group :sleep_record
      end
      error code: 404, desc: 'Not found'
      error code: 422, desc: 'Not destroyed due to is prevented'
      def destroy
        @sleep_record.destroy!

        render :show, status: :ok, locals: { sleep_record: @sleep_record }
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_sleep_record
        @sleep_record = current_user.sleep_records.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def sleep_record_params
        params.fetch(:sleep_record, {}).permit(:clocked_in, :clocked_out)
      end
    end
  end
end
