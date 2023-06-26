# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                 :bigint           not null, primary key
#  name               :string           not null
#  email              :string           default(""), not null
#  encrypted_password :string           default(""), not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  jti                :string           default(""), not null
#
class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: self

  validates :name, presence: true

  has_many :sleep_records, dependent: :destroy

  has_many :follower_relationships, foreign_key: :following_id, class_name: 'UserRelationship', inverse_of: :following,
                                    dependent: :destroy
  has_many :followers, through: :follower_relationships

  has_many :following_relationships, foreign_key: :follower_id, class_name: 'UserRelationship', inverse_of: :follower,
                                     dependent: :destroy
  has_many :followings, through: :following_relationships
end
