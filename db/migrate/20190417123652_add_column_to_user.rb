class AddColumnToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :uid, :string, default: "5555"
    add_column :users, :employee_number, :integer
    add_column :users, :superior, :boolean, default: false
  end
end
