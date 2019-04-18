class AddColumnToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :card_id, :string
    add_column :users, :employee_id, :integer
    add_column :users, :sup, :boolean, default: false
  end
end
