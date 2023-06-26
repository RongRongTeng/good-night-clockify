# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Followings::SleepRecords', aggregate_failures: true do
  let(:me) { create(:user) }

  # rubocop:disable RSpec/MultipleMemoizedHelpers
  describe 'GET /api/v1/followings/sleep_records' do
    subject do
      travel_to(DateTime.new(2023, 6, 14, 0, 0, 0)) do
        get api_v1_followings_sleep_records_url, headers: authenticated_header(me)
      end
    end

    let(:users) { create_list(:user, 2) }

    let!(:my_sleep_record) { create(:sleep_record, user: me) }

    let!(:my_following_sleep_record_1) do
      travel_to(DateTime.new(2023, 6, 2, 0, 0, 0)) do
        create(:sleep_record, user: users[1], clocked_in: DateTime.new(2023, 6, 1, 13, 0, 0),
                              clocked_out: DateTime.new(2023, 6, 1, 14, 29, 39))
      end
    end

    let!(:my_following_sleep_record_2) do
      travel_to(DateTime.new(2023, 6, 7, 0, 0, 0)) do
        create(:sleep_record, user: users[0], clocked_in: DateTime.new(2023, 6, 5, 21, 0, 0),
                              clocked_out: DateTime.new(2023, 6, 5, 22, 30, 0))
      end
    end

    let!(:my_following_sleep_record_3) do
      travel_to(DateTime.new(2023, 6, 7, 0, 0, 0)) do
        create(:sleep_record, user: users[0], clocked_in: DateTime.new(2023, 6, 6, 16, 0, 0),
                              clocked_out: DateTime.new(2023, 6, 6, 23, 30, 0))
      end
    end

    let!(:my_following_sleep_record_4) do
      travel_to(DateTime.new(2023, 6, 7, 0, 0, 0)) do
        create(:sleep_record, user: users[1], clocked_in: DateTime.new(2023, 6, 6, 16, 0, 0),
                              clocked_out: nil)
      end
    end

    let!(:my_following_sleep_record_5) do
      travel_to(DateTime.new(2023, 6, 10, 0, 0, 0)) do
        create(:sleep_record, user: users[1], clocked_in: DateTime.new(2023, 6, 7, 16, 0, 0),
                              clocked_out: DateTime.new(2023, 6, 8, 3, 30, 0))
      end
    end

    let!(:not_my_following_sleep_record) { create(:sleep_record) }

    before do
      users.each do |user|
        create(:user_relationship, follower: me, following: user)
      end
    end

    it 'gets sleep records of followings from previous week and orders by sleep duration descending' do
      subject

      expect(response).to have_http_status :ok
      expect(json_body).to eq(
        [
          {
            id: my_following_sleep_record_5.id,
            user_id: users[1].id,
            clocked_in: '2023-06-07T16:00:00.000Z',
            clocked_out: '2023-06-08T03:30:00.000Z',
            duration_in_minutes: 690,
            created_at: '2023-06-10T00:00:00.000Z',
            updated_at: '2023-06-10T00:00:00.000Z'
          },
          {
            id: my_following_sleep_record_3.id,
            user_id: users[0].id,
            clocked_in: '2023-06-06T16:00:00.000Z',
            clocked_out: '2023-06-06T23:30:00.000Z',
            duration_in_minutes: 450,
            created_at: '2023-06-07T00:00:00.000Z',
            updated_at: '2023-06-07T00:00:00.000Z'
          },
          {
            id: my_following_sleep_record_2.id,
            user_id: users[0].id,
            clocked_in: '2023-06-05T21:00:00.000Z',
            clocked_out: '2023-06-05T22:30:00.000Z',
            duration_in_minutes: 90,
            created_at: '2023-06-07T00:00:00.000Z',
            updated_at: '2023-06-07T00:00:00.000Z'
          },
          {
            id: my_following_sleep_record_4.id,
            user_id: users[1].id,
            clocked_in: '2023-06-06T16:00:00.000Z',
            clocked_out: nil,
            duration_in_minutes: nil,
            created_at: '2023-06-07T00:00:00.000Z',
            updated_at: '2023-06-07T00:00:00.000Z'
          }
        ]
      )
    end

    context 'with paganiation' do
      subject do
        travel_to(DateTime.new(2023, 6, 14, 0, 0, 0)) do
          get api_v1_followings_sleep_records_url(page_size: 2, page: 2), headers: authenticated_header(me)
        end
      end

      it do
        subject

        expect(response).to have_http_status(:ok)
        expect(json_body).to eq(
          [
            {
              id: my_following_sleep_record_2.id,
              user_id: users[0].id,
              clocked_in: '2023-06-05T21:00:00.000Z',
              clocked_out: '2023-06-05T22:30:00.000Z',
              duration_in_minutes: 90,
              created_at: '2023-06-07T00:00:00.000Z',
              updated_at: '2023-06-07T00:00:00.000Z'
            },
            {
              id: my_following_sleep_record_4.id,
              user_id: users[1].id,
              clocked_in: '2023-06-06T16:00:00.000Z',
              clocked_out: nil,
              duration_in_minutes: nil,
              created_at: '2023-06-07T00:00:00.000Z',
              updated_at: '2023-06-07T00:00:00.000Z'
            }
          ]
        )
      end
    end
    # rubocop:enable RSpec/MultipleMemoizedHelpers
  end
end
