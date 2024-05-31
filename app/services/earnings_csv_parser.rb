require 'csv'
require_relative '../models/earning'  # Add this line if Earning model is not being loaded

class EarningsCsvParser
  # file = CSV string
  def initialize(file, employer_id)
      @file = file
      @employer = get_employer(employer_id)
      @employer_csv_format = get_employer_csv_format
  end

  def create_earnings
      csv = CSV.parse(@file, headers: true)
      errors = []
      csv.each do |row|
        e = create_earning(row)
        if e.valid?
          e.save
        else
          errors << "Error with row #{row}: #{e.errors.full_messages}"
        end
      end
      display_errors errors
  end

  private

  def get_employer_csv_format
    EmployerCsvFormat.find_by(employer_id: @employer.id)
  end
  
  def get_employer employer_id
    Employer.find_by!(id: employer_id) 
  end
  
  def get_employee_id external_ref
    puts external_ref
    Employee.find_by(external_ref: external_ref, employer_id: @employer.id)&.id
  end
  
  def create_earning row
    external_ref_header = @employer_csv_format.external_ref_header
  
    Earning.new(
      earning_date: format_date(row), 
      amount: format_amount(row), 
      employee_id: get_employee_id(row[external_ref_header])
    ) 
  end
    
  def format_date row
    date_header = @employer_csv_format.date_header
    strftime_format = @employer_csv_format.date_format
    date = row[date_header]
    begin
      new_date = Date.strptime(date, strftime_format).strftime("%b %d, %Y")
      return new_date
    rescue Date::Error => e
      puts "Invalid date: #{date} cannot be parsed with format #{strftime_format}"
      nil
    end
  end

  def format_amount row
    amount_header = @employer_csv_format.amount_header
    amount_format = @employer_csv_format.amount_format
    amount = row[amount_header]
    if amount_format == 'STRING'
      amount.gsub(/[^0-9.]/, '').to_f
    elsif amount_format == 'DECIMAL'
      amount.to_f
    end
  end

  def display_errors errors
    if errors.any?
      puts "There were errors with the following rows: "
      errors.each { |error| puts error }
    end
  end
end