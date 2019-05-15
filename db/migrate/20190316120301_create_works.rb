class CreateWorks < ActiveRecord::Migration[5.1]
  def change
    create_table :works do |t|
      t.date :work_date
      t.datetime :time_in
      t.datetime :time_out
      t.string :note
      t.integer :work_change_status
      t.integer :work_change_approver_id
      t.string :checked_next_day
      t.string :checked_confirm
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
