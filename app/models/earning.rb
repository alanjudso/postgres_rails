class Earning < ApplicationRecord
  belongs_to :employee
  validates :earning_date, presence: true
  validates :amount, presence: true
  validates :employee_id, presence: true
end
