class CreateWorkLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :work_logs do |t|
      t.references :user, foreign_key: true
      t.string :user_name
      t.integer :work_change_approver_id
      t.string :work_change_approver_name
      t.boolean :work_change_approved?, default: false
      t.date :work_date
      t.datetime :pre_time_in
      t.datetime :pre_time_out
      t.datetime :post_time_in
      t.datetime :post_time_out
      
      t.timestamps
    end
  end
end
