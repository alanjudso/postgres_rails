# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

first_employer = Employer.create(name: "Acme Co")
second_employer = Employer.create(name: "BetaCo")

# make two employees for each of first_employer and second employer.
first_employer.employees.create(name: "John Doe", external_ref: "A123")
first_employer.employees.create(name: "Jane Doe", external_ref: "B456")
second_employer.employees.create(name: "John Smith", external_ref: "123")
second_employer.employees.create(name: "Jane Smith", external_ref: "456")

# create employer_csv_format for each employer
EmployerCsvFormat.create(employer: first_employer, external_ref_header: "EmployeeNumber", date_header: "CheckDate", date_format: "%m/%d/%Y", amount_header: "Amount", amount_format: "STRING")
EmployerCsvFormat.create(employer: second_employer, external_ref_header: "employee", date_header: "earningDate", date_format: "%Y-%m-%d", amount_header: "netAmount", amount_format: "DECIMAL")

csv_1 = "EmployeeNumber,CheckDate,Amount\nA123,12/14/2021,$800.50\nB456,12/21/2021,$740.00"
csv_2 = "earningDate,employee,netAmount\n2021-12-14,123,800.50\n2021-12-21,456,740.00"
