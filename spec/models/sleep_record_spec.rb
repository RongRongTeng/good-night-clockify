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
end
