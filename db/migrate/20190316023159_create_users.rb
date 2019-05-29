class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.datetime :basic_work_time, default: Time.zone.parse("2019/03/20 07:30")
      t.datetime :work_time, default: Time.zone.parse("2019/03/20 08:00")
      t.datetime :designed_work_start_time, default: Time.zone.parse("2019/03/20 09:00")
      t.datetime :designed_work_end_time, default: Time.zone.parse("2019/03/20 18:00")
      t.boolean :admin, default: false
      t.string :affiliation

      t.timestamps
    end
  end
end
