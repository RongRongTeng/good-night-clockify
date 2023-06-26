# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Followings', aggregate_failures: true do
  let(:me) { create(:user) }

  describe 'GET /api/v1/followings' do
    subject { get api_v1_followings_url, headers: authenticated_header(me) }

    let(:users) { create_list(:user, 2) }

    let!(:my_following_1) do
      travel_to(DateTime.new(2023, 6, 1, 0, 0, 0)) { create(:user_relationship, follower: me, following: users[1]) }
    end

    let!(:my_following_2) do
      travel_to(DateTime.new(2023, 6, 4, 14, 29, 39)) { create(:user_relationship, follower: me, following: users[0]) }
    end

    let!(:not_my_following) { create(:user_relationship) }

    it 'renders a successful response' do
      subject

      expect(response).to have_http_status :ok
      expect(json_body).to eq(
        [
          {
            id: my_following_2.id,
            user_id: users[0].id,
            created_at: '2023-06-04T14:29:39.000Z',
            updated_at: '2023-06-04T14:29:39.000Z'
          },
          {
            id: my_following_1.id,
            user_id: users[1].id,
            created_at: '2023-06-01T00:00:00.000Z',
            updated_at: '2023-06-01T00:00:00.000Z'
          }
        ]
      )
    end

    context 'with paganiation' do
      subject { get api_v1_followings_url(page_size: 1, page: 2), headers: authenticated_header(me) }

      it do
        subject

        expect(response).to have_http_status(:ok)
        expect(json_body).to eq(
          [
            {
              id: my_following_1.id,
              user_id: users[1].id,
              created_at: '2023-06-01T00:00:00.000Z',
              updated_at: '2023-06-01T00:00:00.000Z'
            }
          ]
        )
      end
    end
  end

  describe 'POST /api/v1/followings' do
    subject do
      travel_to(DateTime.new(2023, 6, 1, 0, 0, 0)) do
        post api_v1_followings_url, headers: authenticated_header(me),
                                    params: { following: params },
                                    as: :json
      end
    end

    let(:user) { create(:user) }

    context 'with valid parameters' do
      let(:params) do
        { user_id: user.id }
      end

      it 'creates a new following' do
        expect { subject }.to change(UserRelationship, :count).by(1)
      end

      it 'renders a JSON response with the new following' do
        subject

        expect(response).to have_http_status(:created)
        expect(json_body).to match(
          {
            id: be_present,
            user_id: user.id,
            created_at: '2023-06-01T00:00:00.000Z',
            updated_at: '2023-06-01T00:00:00.000Z'
          }
        )
      end
    end

    context 'with invalid parameters' do
      let(:params) do
        { user_id: user.id }
      end

      before { create(:user_relationship, follower: me, following: user) }

      it 'does not create a new following' do
        expect { subject }.not_to change(UserRelationship, :count)
      end

      it 'renders a JSON response with error messages' do
        subject

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_body).to eq(
          {
            status: '422',
            error: 'Unprocessable Entity',
            detail: { following_id: ['has already been taken'] }
          }
        )
      end
    end

    context 'with missing parameter' do
      let(:params) do
        { user_id: nil }
      end

      it 'renders a JSON response with error messages' do
        subject

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_body).to eq(
          {
            status: '422',
            error: 'Unprocessable Entity',
            detail: "Invalid parameter 'user_id' value nil: Must be a number."
          }
        )
      end
    end
  end

  describe 'DELETE /api/v1/followings/:id' do
    subject do
      delete api_v1_following_url(following), headers: authenticated_header(me), as: :json
    end

    let(:user) { create(:user) }

    let!(:following) do
      travel_to(DateTime.new(2023, 6, 1, 0, 0, 0)) { create(:user_relationship, follower: me, following: user) }
    end

    context 'when following is found' do
      it 'destroys the requested following' do
        expect { subject }.to change(UserRelationship, :count).by(-1)
      end

      it 'renders a JSON response with the deleted following' do
        subject

        expect(response).to have_http_status(:ok)
        expect(json_body).to match(
          {
            id: following.id,
            user_id: user.id,
            created_at: '2023-06-01T00:00:00.000Z',
            updated_at: '2023-06-01T00:00:00.000Z'
          }
        )
      end
    end

    context 'when following is not found due to not belongs to me' do
      let!(:following) { create(:user_relationship) }

      it 'renders a not found response' do
        subject

        expect(response).to have_http_status(:not_found)
        expect(json_body).to eq(
          {
            status: '404',
            error: 'Not Found',
            detail: "Couldn't find UserRelationship with 'id'=#{following.id} " \
                    '[WHERE "user_relationships"."follower_id" = $1]'
          }
        )
      end
    end
  end
end
