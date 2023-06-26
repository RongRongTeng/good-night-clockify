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
class UserRelationship < ApplicationRecord
  belongs_to :follower, class_name: 'User'
  belongs_to :following, class_name: 'User'

  validates :following_id, uniqueness: { scope: :follower_id },
                           exclusion: { in: proc { |record| [record.follower_id] } }
end
