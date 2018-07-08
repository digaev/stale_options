class TestModel < ActiveRecord::Base
  self.table_name = 'test_models'

  attribute :created_at, :datetime
  attribute :updated_at, :datetime

  scope :most_recent, -> { order(created_at: :desc) }
end
