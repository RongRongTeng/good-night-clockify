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
FactoryBot.define do
  factory :user do
    sequence(:name)  { |n| "User #{n}" }
    sequence(:email) { |n| "factory_bot_email_#{n}@example.com" }
    password { SecureRandom.base64(10) }
  end
end
