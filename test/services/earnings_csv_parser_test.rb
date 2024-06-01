require 'test_helper'

class EarningsCsvParserTest < ActiveSupport::TestCase
  def setup
    @first_employer = Employer.create(name: "Acme Co")
    @second_employer = Employer.create(name: "BetaCo")
    @third_employer = Employer.create(name: "GammaCo")

    @first_employer.employees.create(name: "Alan Judson", external_ref: "A123")
    @first_employer.employees.create(name: "Danila Szabo", external_ref: "B456")
    @second_employer.employees.create(name: "Daniel Sabourin", external_ref: "123")
    @second_employer.employees.create(name: "Yuval Kordov", external_ref: "456")
    @third_employer.employees.create(name: "Daniel Johnston", external_ref: "789")
    
    EmployerCsvFormat.create(employer: @first_employer, external_ref_header: "EmployeeNumber", date_header: "CheckDate", date_format: "%m/%d/%Y", amount_header: "Amount", amount_format: "STRING")
    EmployerCsvFormat.create(employer: @second_employer, external_ref_header: "employee", date_header: "earningDate", date_format: "%Y-%m-%d", amount_header: "netAmount", amount_format: "DECIMAL")
    
    @csv_1 = "EmployeeNumber,CheckDate,Amount\nA123,12/14/2021,$800.50\nB456,12/21/2021,$740.00"
    @csv_2 = "earningDate,employee,netAmount\n2021-12-14,123,800.50\n2021-12-21,456,740.00"
    @csv_invalid_date = "EmployeeNumber,CheckDate,Amount\nA123,NOT_A_DATE,$49.99"
  end
  
  test "should create earnings for first employer" do
    parser = EarningsCsvParser.new(@csv_1, @first_employer.id)
    assert_difference 'Earning.count', 2 do
      parser.create_earnings
    end
    
    earnings = Earning.where(employee_id: @first_employer.employees.pluck(:id))
    assert_equal 2, earnings.count
    assert_includes earnings.map(&:amount), 800.50
    assert_includes earnings.map(&:amount), 740.00
  end
  
  test "should create earnings for second employer" do
    parser = EarningsCsvParser.new(@csv_2, @second_employer.id)
    assert_difference 'Earning.count', 2 do
      parser.create_earnings
    end
    
    earnings = Earning.where(employee_id: @second_employer.employees.pluck(:id))
    assert_equal 2, earnings.count
    assert_includes earnings.map(&:amount), 800.50
    assert_includes earnings.map(&:amount), 740.00
  end

  test "show return errors if there's no employer" do
    assert_raises ActiveRecord::RecordNotFound do
      parser = EarningsCsvParser.new(@csv_1, 999)
      parser.create_earnings
    end
  end

  test "show return errors if there's no employer csv format" do
    assert_raises ActiveRecord::RecordNotFound do
      parser = EarningsCsvParser.new(@csv_1, @third_employer.id)
      parser.create_earnings
    end
  end

  test "should not create earning if validations fail" do
    parser = EarningsCsvParser.new(@csv_invalid_date, @first_employer.id)
    parser.create_earnings
    assert_equal 2, Earning.count
  end
end
