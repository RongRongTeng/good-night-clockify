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
require 'rails_helper'

RSpec.describe UserRelationship do
  pending "add some examples to (or delete) #{__FILE__}"
end
