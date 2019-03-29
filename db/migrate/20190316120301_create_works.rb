class CreateWorks < ActiveRecord::Migration[5.1]
  def change
    create_table :works do |t|
      t.date :work_date
      t.datetime :time_in
      t.datetime :time_out
      t.string :note
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
