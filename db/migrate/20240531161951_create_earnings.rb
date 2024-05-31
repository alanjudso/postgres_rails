class CreateEarnings < ActiveRecord::Migration[7.0]
  def change
    create_table :earnings do |t|
      t.date :earning_date
      t.decimal :amount
      t.references :employee, null: false, foreign_key: true

      t.timestamps
    end
  end
end
