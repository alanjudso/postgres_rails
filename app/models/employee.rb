class Employee < ApplicationRecord
  belongs_to :employer
  has_many :earnings, dependent: :destroy
  validates :name, :external_ref, presence: true
end
