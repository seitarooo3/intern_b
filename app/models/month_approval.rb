class MonthApproval < ApplicationRecord
  belongs_to :user
  enum month_approval_status: { "未申請" => 1, "申請中" => 2, "承認" => 3, "否認" => 4 }
  
end
