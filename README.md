# README

Hi - I've added seed data!

- Make sure you're using ruby-3.2.2
- Run `bundle install`
- Database creation
  `bin/rails db:create`
  `bin/rails db:migrate`
  `bin/rails db:migrate RAILS_ENV=test`
- Database initialization
  `bin/rails db:seed`
- Ruby version
  ruby-3.2.2
- How to run it in console?
  - `e = EarningsCsvParser.new "EmployeeNumber,CheckDate,Amount\nA123,dumb,$800.50\nB456,12/21/2021,$740.00", 1`
  - `e.create_earnings`
- How to run the test suite
  `bin/rails db:migrate RAILS_ENV=test`
  `bin/rails test`
- How I would I optimize this?
  - This class violates Single Responsibility by parsing CSV and creating earnings. As parsing becomes more complicated, I would take it into it's own class.
  - Proper validations on all models - example: unique names and exteral_ref would be unique within each program, but not unique globally.
    - You could add a validation so that you couldn't create an earning for the same employee on the same date, this would help to avoid the same CSV being processed twice.
  - I would make the formatting of amount and date more robust. Maybe it would handle negative numbers, if relavant, for example.
  - I would add more robust error handling for the parser.
  - I might add the ability to pass in a path to a csv rather than paste in a string of a csv
  - I might use some meta programming to clean up the assigning of row data
  - I might create a table that captures errors and stores the name of the CSV, the error, the employeer, and the row. This way you can notice patterns of errors and mitigate future risks.

NOTE: I added users table when I was creating the postgresql project. I didn't remove them but I could just make a migration in the time it took me to write this :| ¯\_(ツ)\_/¯

Things I changed:

- I added `!` to the `.find_by` in the GET calls for Employer and EmployerCsvFormat, so it returns an error if one of them is missing. After all, you need those to run yit.
- I replace `puts` with Rails.logger.info because they are persisted and might be useful if you have to keep track of which rows were not formatted correctly. It's a trade-off, because if this is only used in the terminal, puts messages print right to the terminal, but can have unintended side effects.
- I created instance variables for the employer and employer_csv_format - they both are fetched during initialization.
  If the employer is missing, it fails right away. It also cuts down on calling them all the time throughout the class.
- I added some simple unit tests. Not 100% coverage, but just enough to let you know I can make tests.
- I changed the 'amount' string formatter to strip everything except numbers and spaces (amount.gsub(/[^0-9.]/, '').to_f)
- I made create_earnings be a much smaller method and extracted the logic into many smaller methods.
- I added a formatter to standardize the result of the date and return nil if it was invalid (this will trigger validations in Earning model)
- I have all errors printing out through Rails.logger.info. Actual errors in the Earning model will be caught through validations and not created.
