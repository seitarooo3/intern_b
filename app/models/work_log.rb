class WorkLog < ApplicationRecord
  belongs_to :user
  
  def self.search(user, timea, timeb)
    return WorkLog.where(user_id: user.id, work_date: timea..timeb, work_change_approved?: true, )
  end
  
  
end
