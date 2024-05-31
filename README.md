# README

Hi - I've added seed data!

- Database creation
  `rails db:migrate`
- Database initialization
  `rails db:seed`
- Ruby version
  ruby-3.2.2
- How to run it in console?
  - `e = EarningsCsvParser.new "EmployeeNumber,CheckDate,Amount\nA123,dumb,$800.50\nB456,12/21/2021,$740.00", 1`
  - `e.create_earnings`
- How to run the test suite
  `bin/rails db:migrate RAILS_ENV=test`
  `bin/rails test`
- How I would I optimize this?
  - Proper validations on all models - example: unique names and exteral_ref would be unique within each program, but not unique globally.
    - You could add a validation so that you couldn't create an earning for the same employee on the same date, this would help to avoid the same CSV being processed twice.
  - I would make the formatting of amount and date more robust. Maybe it would handle negative numbers, if relavant, for example.
  - I would add more robust error handling for the parser.
  - I might add the ability to pass in a path to a csv rather than paste in a string of a csv
  - I might use some meta programming to clean up the assigning of row data

NOTE: I added users table when I was creating the postgresql project. I didn't remove them but I could just make a migration in the time it took me to write this :| ¯\_(ツ)\_/¯

Things I changed:

- I created instance variables for the employer and employer_csv_format - they both are fetched during initialization.
  If the employer is missing, it fails right away. It also cuts down on calling them all the time throughout the class.
- I added some simple unit tests. Not 100% coverage, but just enough to let you know I can make tests.
- I changed the 'amount' string formatter to strip everything except numbers and spaces (amount.gsub(/[^0-9.]/, '').to_f)
- I made create_earnings be a much smaller method and extracted the logic into many smaller methods.
- I added a formatter to standardize the result of the date and return nil if it was invalid (this will trigger validations in Earning model)
- I have all the errors printing out to the terminal with the affected row
