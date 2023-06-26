# frozen_string_literal: true

class AddBtreeGistExtension < ActiveRecord::Migration[7.0]
  def up
    execute 'CREATE EXTENSION IF NOT EXISTS btree_gist'
  end

  def down
    execute 'DROP EXTENSION IF EXISTS btree_gist'
  end
end
