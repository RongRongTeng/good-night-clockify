# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::SleepRecords', aggregate_failures: true do
  let(:me) { create(:user) }

  shared_examples 'when sleep record is not found due to not belongs to me' do
    let!(:sleep_record) { create(:sleep_record) }

    it 'renders a not found response' do
      subject

      expect(response).to have_http_status(:not_found)
      expect(json_body).to eq(
        {
          status: '404',
          error: 'Not Found',
          detail: "Couldn't find SleepRecord with 'id'=#{sleep_record.id} [WHERE \"sleep_records\".\"user_id\" = $1]"
        }
      )
    end
  end

  describe 'GET /api/v1/sleep_records' do
    subject { get api_v1_sleep_records_url, headers: authenticated_header(me) }

    let!(:my_sleep_record_1) do
      travel_to(DateTime.new(2023, 6, 1, 0, 0, 0)) do
        create(:sleep_record, user: me, clocked_in: DateTime.new(2023, 6, 1, 0, 0, 0), clocked_out: nil)
      end
    end

    let!(:my_sleep_record_2) do
      travel_to(DateTime.new(2023, 6, 4, 14, 29, 39)) do
        create(:sleep_record, user: me, clocked_in: DateTime.new(2023, 6, 1, 13, 0, 0),
                              clocked_out: DateTime.new(2023, 6, 1, 14, 29, 39))
      end
    end

    let!(:my_sleep_record_3) do
      travel_to(DateTime.new(2023, 6, 3, 23, 0, 0)) do
        create(:sleep_record, user: me, clocked_in: DateTime.new(2023, 6, 3, 21, 0, 0),
                              clocked_out: DateTime.new(2023, 6, 3, 22, 30, 0))
      end
    end

    let!(:not_my_sleep_record) { create(:sleep_record) }

    it 'renders a successful response' do
      subject

      expect(response).to have_http_status :ok
      expect(json_body).to eq(
        [
          {
            id: my_sleep_record_2.id,
            clocked_in: '2023-06-01T13:00:00.000Z',
            clocked_out: '2023-06-01T14:29:39.000Z',
            duration_in_minutes: 90,
            created_at: '2023-06-04T14:29:39.000Z',
            updated_at: '2023-06-04T14:29:39.000Z'
          },
          {
            id: my_sleep_record_3.id,
            clocked_in: '2023-06-03T21:00:00.000Z',
            clocked_out: '2023-06-03T22:30:00.000Z',
            duration_in_minutes: 90,
            created_at: '2023-06-03T23:00:00.000Z',
            updated_at: '2023-06-03T23:00:00.000Z'
          },
          {
            id: my_sleep_record_1.id,
            clocked_in: '2023-06-01T00:00:00.000Z',
            clocked_out: nil,
            duration_in_minutes: nil,
            created_at: '2023-06-01T00:00:00.000Z',
            updated_at: '2023-06-01T00:00:00.000Z'
          }
        ]
      )
    end

    context 'with paganiation' do
      subject { get api_v1_sleep_records_url(page_size: 1, page: 2), headers: authenticated_header(me) }

      it do
        subject

        expect(response).to have_http_status(:ok)
        expect(json_body).to eq(
          [
            {
              id: my_sleep_record_3.id,
              clocked_in: '2023-06-03T21:00:00.000Z',
              clocked_out: '2023-06-03T22:30:00.000Z',
              duration_in_minutes: 90,
              created_at: '2023-06-03T23:00:00.000Z',
              updated_at: '2023-06-03T23:00:00.000Z'
            }
          ]
        )
      end
    end
  end

  describe 'GET /api/v1/sleep_records/:id' do
    subject { get api_v1_sleep_record_url(sleep_record), headers: authenticated_header(me) }

    context 'when sleep record is found' do
      let!(:sleep_record) do
        travel_to(DateTime.new(2023, 6, 1, 0, 0, 0)) do
          create(:sleep_record, user: me, clocked_in: DateTime.new(2023, 6, 1, 0, 0, 0), clocked_out: nil)
        end
      end

      it 'renders a successful response' do
        subject

        expect(response).to have_http_status :ok
        expect(json_body).to eq(
          {
            id: sleep_record.id,
            clocked_in: '2023-06-01T00:00:00.000Z',
            clocked_out: nil,
            duration_in_minutes: nil,
            created_at: '2023-06-01T00:00:00.000Z',
            updated_at: '2023-06-01T00:00:00.000Z'
          }
        )
      end
    end

    it_behaves_like 'when sleep record is not found due to not belongs to me'
  end

  describe 'POST /api/v1/sleep_records' do
    subject do
      travel_to(DateTime.new(2023, 6, 1, 0, 0, 0)) do
        post api_v1_sleep_records_url, headers: authenticated_header(me),
                                       params: { sleep_record: params },
                                       as: :json
      end
    end

    context 'with valid parameters' do
      let(:params) do
        { clocked_in: DateTime.new(2023, 6, 1, 0, 0, 0) }
      end

      it 'creates a new SleepRecord' do
        expect { subject }.to change(SleepRecord, :count).by(1)
      end

      it 'renders a JSON response with the new SleepRecord' do
        subject

        expect(response).to have_http_status(:created)
        expect(json_body).to match(
          {
            id: be_present,
            clocked_in: '2023-06-01T00:00:00.000Z',
            clocked_out: nil,
            duration_in_minutes: nil,
            created_at: '2023-06-01T00:00:00.000Z',
            updated_at: '2023-06-01T00:00:00.000Z'
          }
        )
      end
    end

    context 'with invalid parameters' do
      let(:params) do
        { clocked_in: DateTime.new(2023, 6, 1, 0, 0, 0), clocked_out: DateTime.new(2023, 5, 31, 0, 0, 0) }
      end

      it 'does not create a new SleepRecord' do
        expect { subject }.not_to change(SleepRecord, :count)
      end

      it 'renders a JSON response with error messages' do
        subject

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_body).to eq(
          {
            status: '422',
            error: 'Unprocessable Entity',
            detail: { clocked_out: ['must be greater than 2023-06-01 00:00:00 UTC'] }
          }
        )
      end
    end

    context 'with missing parameter' do
      let(:params) do
        { clocked_in: nil }
      end

      it 'renders a JSON response with error messages' do
        subject

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_body).to eq(
          {
            status: '422',
            error: 'Unprocessable Entity',
            detail: "Invalid parameter 'clocked_in' value nil: Must be a valid ISO 8601 datetime format"
          }
        )
      end
    end
  end

  describe 'PATCH /api/v1/sleep_records/:id' do
    subject do
      travel_to(DateTime.new(2023, 6, 2, 0, 0, 0)) do
        patch api_v1_sleep_record_url(sleep_record), headers: authenticated_header(me),
                                                     params: { sleep_record: params },
                                                     as: :json
      end
    end

    let(:params) do
      { clocked_out: DateTime.new(2023, 6, 1, 3, 0, 0) }
    end

    context 'when sleep record is found' do
      let!(:sleep_record) do
        travel_to(DateTime.new(2023, 6, 1, 0, 0, 0)) do
          create(:sleep_record, user: me, clocked_in: DateTime.new(2023, 6, 1, 0, 0, 0), clocked_out: nil)
        end
      end

      context 'with valid parameters' do
        it 'renders a JSON response with the updated SleepRecord' do
          subject

          expect(response).to have_http_status(:ok)
          expect(json_body).to match(
            {
              id: be_present,
              clocked_in: '2023-06-01T00:00:00.000Z',
              clocked_out: '2023-06-01T03:00:00.000Z',
              duration_in_minutes: 180,
              created_at: '2023-06-01T00:00:00.000Z',
              updated_at: '2023-06-02T00:00:00.000Z'
            }
          )
        end
      end

      context 'with invalid parameters' do
        let!(:overlapped_sleep_record) do
          create(:sleep_record, user: me, clocked_in: DateTime.new(2023, 6, 1, 3, 0, 0), clocked_out: nil)
        end

        it 'renders a JSON response with error messages' do
          subject

          expect(response).to have_http_status(:unprocessable_entity)
          expect(json_body).to eq(
            {
              status: '422',
              error: 'Unprocessable Entity',
              detail: { base: ["Overlaps with SleepRecord##{overlapped_sleep_record.id} (2023-06-01 03:00:00 UTC ~ )"] }
            }
          )
        end
      end

      context 'with invalid parameter format' do
        let(:params) do
          { clocked_in: 'wrong format' }
        end

        it 'renders a JSON response with error messages' do
          subject

          expect(response).to have_http_status(:unprocessable_entity)
          expect(json_body).to eq(
            {
              status: '422',
              error: 'Unprocessable Entity',
              detail: "Invalid parameter 'clocked_in' value \"wrong format\": Must be a valid ISO 8601 datetime format"
            }
          )
        end
      end
    end

    it_behaves_like 'when sleep record is not found due to not belongs to me'
  end

  describe 'DELETE /api/v1/sleep_records/:id' do
    subject do
      delete api_v1_sleep_record_url(sleep_record), headers: authenticated_header(me), as: :json
    end

    let!(:sleep_record) do
      travel_to(DateTime.new(2023, 6, 1, 0, 0, 0)) do
        create(:sleep_record, user: me, clocked_in: DateTime.new(2023, 6, 1, 0, 0, 0), clocked_out: nil)
      end
    end

    it 'destroys the requested SleepRecord' do
      expect { subject }.to change(SleepRecord, :count).by(-1)
    end

    it 'renders a JSON response with the deleted SleepRecord' do
      subject

      expect(response).to have_http_status(:ok)
      expect(json_body).to match(
        {
          id: be_present,
          clocked_in: '2023-06-01T00:00:00.000Z',
          clocked_out: nil,
          duration_in_minutes: nil,
          created_at: '2023-06-01T00:00:00.000Z',
          updated_at: '2023-06-01T00:00:00.000Z'
        }
      )
    end

    it_behaves_like 'when sleep record is not found due to not belongs to me'
  end
end
