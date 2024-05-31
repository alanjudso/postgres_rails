class CreateEmployerCsvFormats < ActiveRecord::Migration[7.0]
  def change
    create_table :employer_csv_formats do |t|
      t.string :external_ref_header
      t.string :date_header
      t.string :date_format
      t.string :amount_header
      t.string :amount_format
      t.references :employer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
