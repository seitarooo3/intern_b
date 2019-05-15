class Work < ApplicationRecord
  belongs_to :user
  enum work_change_status: { "未申請" => 1, "申請中" => 2, "承認" => 3, "否認" => 4 }
end
