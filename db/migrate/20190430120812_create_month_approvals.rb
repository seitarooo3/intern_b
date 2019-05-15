class CreateMonthApprovals < ActiveRecord::Migration[5.1]
  def change
    create_table :month_approvals do |t|
      t.references :user, foreign_key: true
      t.date :work_month
      t.integer :month_approval_status, default: 1
      t.integer :month_approver_id
      t.string :note
      t.string :checked

      t.timestamps
    end
  end
end
