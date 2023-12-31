# frozen_string_literal: true

require "bundler/inline"

gemfile(true) do
  source "https://rubygems.org"

  git_source(:github) { |repo| "https://github.com/#{repo}.git" }

  gem "rails", "7.1"
  gem "sqlite3"
  gem 'pry'
end

require "active_record"
require "logger"
require "minitest/autorun"
require 'pry'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

ActiveRecord::Schema.define do
  create_table :tenants, force: true do |t|
  end

  create_table :comments, force: true do |t|
    t.integer :tenant_id
    t.integer :author_id
  end

end

class Tenant < ActiveRecord::Base
end


class Comment < ActiveRecord::Base
  query_constraints :tenant_id, :id

  belongs_to :tenant
end

class BugTest < Minitest::Test
  def test_assoc
    tenant = Tenant.create!
    comment = Comment.new(tenant: tenant)

    assert_equal tenant, comment.tenant
    assert_equal tenant.id, comment.tenant_id
  end
end