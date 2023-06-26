# frozen_string_literal: true

# == Schema Information
#
# Table name: user_relationships
#
#  id           :bigint           not null, primary key
#  follower_id  :bigint           not null
#  following_id :bigint           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
FactoryBot.define do
  factory :user_relationship do
    follower  { association :user }
    following { association :user }
  end
end
