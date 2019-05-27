class CreateBranches < ActiveRecord::Migration[5.1]
  def change
    create_table :branches do |t|
      t.integer :branch_id, unique: true
      t.string :branch_name, unique: true
      t.string :work_type
      t.timestamps
    end
  end
end
