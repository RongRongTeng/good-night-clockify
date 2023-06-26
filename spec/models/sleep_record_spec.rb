# frozen_string_literal: true

# == Schema Information
#
# Table name: sleep_records
#
#  id                  :bigint           not null, primary key
#  user_id             :bigint           not null
#  clocked_in          :datetime         not null
#  clocked_out         :datetime
#  duration_in_minutes :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
require 'rails_helper'

RSpec.describe SleepRecord do
  describe '.from_previous_week_to_now' do
    subject do
      travel_to(DateTime.new(2023, 6, 16, 0, 0, 0)) do
        described_class.from_previous_week_to_now
      end
    end

    let!(:sleep_record_1) do
      create(:sleep_record, clocked_in: DateTime.new(2023, 6, 1, 13, 0, 0),
                            clocked_out: DateTime.new(2023, 6, 1, 14, 29, 39))
    end

    let!(:sleep_record_2) do
      create(:sleep_record, clocked_in: DateTime.new(2023, 6, 5, 21, 0, 0),
                            clocked_out: DateTime.new(2023, 6, 5, 22, 30, 0))
    end

    let!(:sleep_record_3) do
      create(:sleep_record, clocked_in: DateTime.new(2023, 6, 6, 16, 0, 0),
                            clocked_out: DateTime.new(2023, 6, 6, 23, 30, 0))
    end

    let!(:sleep_record_4) do
      create(:sleep_record, clocked_in: DateTime.new(2023, 6, 6, 16, 0, 0),
                            clocked_out: nil)
    end

    let!(:sleep_record_5) do
      create(:sleep_record, clocked_in: DateTime.new(2023, 6, 7, 16, 0, 0),
                            clocked_out: DateTime.new(2023, 6, 8, 3, 30, 0))
    end

    it { is_expected.to contain_exactly(sleep_record_2, sleep_record_3, sleep_record_4, sleep_record_5) }
  end

  describe 'Callbacks' do
    describe '#set_duration_in_minutes' do
      let(:sleep_record) { create(:sleep_record, :clocked_in_only, clocked_in: DateTime.new(2022, 6, 25, 15, 30, 30)) }

      context 'when creates' do
        subject { sleep_record }

        it { expect(subject.duration_in_minutes).to be_nil }
      end

      context 'when updates clocked_out' do
        subject { sleep_record.update!(clocked_out:) }

        context 'with datetime' do
          let(:clocked_out) { DateTime.new(2022, 6, 26, 0, 30, 59) }

          it do
            subject

            expect(sleep_record.duration_in_minutes).to eq 540
          end
        end

        context 'with nil' do
          let(:clocked_out) { nil }

          before { sleep_record.update!(clocked_out: DateTime.new(2022, 6, 26, 0, 30, 59)) }

          it do
            subject

            expect(sleep_record.duration_in_minutes).to be_nil
          end
        end
      end

      context 'when updates clocked_in' do
        subject { sleep_record.update!(clocked_in: DateTime.new(2022, 6, 25, 16, 30, 30)) }

        it do
          subject

          expect(sleep_record.duration_in_minutes).to be_nil
        end
      end
    end
  end

  describe 'Validations' do
    describe '#validate_overlaps_with_others' do
      let(:me) { create(:user) }

      let!(:my_sleep_record_1) do
        create(:sleep_record, user: me, clocked_in: DateTime.new(2023, 6, 1, 0, 0, 0), clocked_out: nil)
      end

      let!(:my_sleep_record_2) do
        create(:sleep_record, user: me, clocked_in: DateTime.new(2023, 6, 1, 13, 0, 0),
                              clocked_out: DateTime.new(2023, 6, 1, 14, 29, 39))
      end

      let!(:not_my_sleep_record) do
        create(:sleep_record, clocked_in: DateTime.new(2023, 6, 1, 14, 0, 0),
                              clocked_out: DateTime.new(2023, 6, 1, 14, 29, 39))
      end

      context 'when is new record' do
        let(:sleep_record) do
          build(:sleep_record, user: me, clocked_in: DateTime.new(2023, 6, 1, 0, 0, 0), clocked_out: nil)
        end

        it :aggregate_failures do
          expect(sleep_record).to be_invalid
          expect(sleep_record.errors.messages)
            .to eq(base: ["Overlaps with SleepRecord##{my_sleep_record_1.id} (2023-06-01 00:00:00 UTC ~ )"])

          sleep_record.clocked_in = DateTime.new(2023, 6, 1, 14, 0, 0)
          expect(sleep_record).to be_invalid
          expect(sleep_record.errors.messages).to eq(base: ["Overlaps with SleepRecord##{my_sleep_record_2.id} " \
                                                            '(2023-06-01 13:00:00 UTC ~ 2023-06-01 14:29:39 UTC)'])
        end
      end

      context 'when is persisted' do
        let!(:sleep_record) do
          create(:sleep_record, user: me, clocked_in: DateTime.new(2023, 5, 31, 0, 0, 0), clocked_out: nil)
        end

        it :aggregate_failures do
          expect(sleep_record).to be_valid

          sleep_record.clocked_out = DateTime.new(2023, 6, 1, 13, 29, 39)
          expect(sleep_record).to be_invalid
          expect(sleep_record.errors.messages).to eq(
            base: [
              "Overlaps with SleepRecord##{my_sleep_record_1.id} (2023-06-01 00:00:00 UTC ~ )",
              "Overlaps with SleepRecord##{my_sleep_record_2.id} " \
              '(2023-06-01 13:00:00 UTC ~ 2023-06-01 14:29:39 UTC)'
            ]
          )

          sleep_record.clocked_out = DateTime.new(2023, 5, 31, 23, 59, 59)
          expect(sleep_record).to be_valid
        end

        it 'does not raise db level error due to TSRANGE lower bound > upper bound' do
          sleep_record.clocked_out = DateTime.new(2022, 6, 1, 13, 29, 39)
          expect(sleep_record).to be_invalid
        end
      end
    end
  end
end
