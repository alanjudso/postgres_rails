class Employer < ApplicationRecord
    has_many :employees, dependent: :destroy
    has_one :employer_csv_format
    validates :name, presence: true
end

