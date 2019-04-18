class Branch < ApplicationRecord
  validates :branch_id, presence: true, uniqueness: true
  validates :branch_name, presence: true, uniqueness: true
end
