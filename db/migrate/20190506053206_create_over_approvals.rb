class CreateOverApprovals < ActiveRecord::Migration[5.1]
  def change
    create_table :over_approvals do |t|
      t.references :user, foreign_key: true
      t.date :over_date
      t.datetime :scheduled_over_time_out
      t.integer :over_approval_status, default: 1
      t.integer :over_approver_id
      t.string :checked_next_day
      t.string :checked_confirm
      t.string :note

      t.timestamps
    end
  end
end
