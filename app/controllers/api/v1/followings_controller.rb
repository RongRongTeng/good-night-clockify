# frozen_string_literal: true

module Api
  module V1
    class FollowingsController < ApplicationController
      include Apipie::Following

      before_action :set_following, only: %i[destroy]

      api :GET, '/v1/followings', 'List followings'
      returns code: 200 do
        param_group :following
      end
      def index
        @followings = current_user.following_relationships
                                  .order(created_at: :desc)
                                  .order(:id)
                                  .page(params[:page])
                                  .per(params[:page_size])
      end

      api :POST, '/v1/followings', 'Create a following'
      param :following, Hash, required: true do
        param :user_id, :number, desc: 'The ID of the user', required: true
      end
      returns code: 201 do
        param_group :following
      end
      error code: 404, desc: 'Not found'
      error code: 422, desc: 'Missing required parameter or invalid parameter'
      def create
        @following = current_user.following_relationships.create!(following_id: following_params[:user_id])

        render :show, status: :created, locals: { following: @following }
      end

      api :DELETE, '/v1/followings/:id', 'Delete a following'
      param :id, :number, desc: 'The ID of the following', required: true
      returns code: 200 do
        param_group :following
      end
      error code: 404, desc: 'Not found'
      error code: 422, desc: 'Not destroyed due to is prevented'
      def destroy
        @following.destroy!

        render :show, status: :ok, locals: { following: @following }
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_following
        @following = current_user.following_relationships.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def following_params
        params.fetch(:following, {}).permit(:user_id)
      end
    end
  end
end
