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
require 'rails_helper'

RSpec.describe User do
  pending "add some examples to (or delete) #{__FILE__}"
end
