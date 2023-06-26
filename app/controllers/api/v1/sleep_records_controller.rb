# frozen_string_literal: true

module Api
  module V1
    class SleepRecordsController < ApplicationController
      before_action :set_sleep_record, only: %i[show update destroy]

      # GET /api/v1/sleep_records
      # GET /api/v1/sleep_records.json
      def index
        @sleep_records = current_user.sleep_records
                                     .order(created_at: :desc)
                                     .order(:id)
                                     .page(params[:page])
                                     .per(params[:page_size])
      end

      # GET /api/v1/sleep_records/1
      # GET /api/v1/sleep_records/1.json
      def show; end

      # POST /api/v1/sleep_records
      # POST /api/v1/sleep_records.json
      def create
        @sleep_record = current_user.sleep_records.create!(sleep_record_params)

        render :show, status: :created, locals: { sleep_record: @sleep_record }
      end

      # PATCH/PUT /api/v1/sleep_records/1
      # PATCH/PUT /api/v1/sleep_records/1.json
      def update
        @sleep_record.update!(sleep_record_params)

        render :show, status: :ok, locals: { sleep_record: @sleep_record }
      end

      # DELETE /api/v1/sleep_records/1
      # DELETE /api/v1/sleep_records/1.json
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
