# frozen_string_literal: true

class CreateUserRelationships < ActiveRecord::Migration[7.0]
  def change
    create_table :user_relationships do |t|
      t.references :follower, foreign_key: { to_table: :users }, null: false
      t.references :following, foreign_key: { to_table: :users }, null: false

      t.timestamps

      t.index %i[follower_id following_id], unique: true
    end
  end
end
