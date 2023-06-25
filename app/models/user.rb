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
end
