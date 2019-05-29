module OverApprovalsHelper
  
  def over_work_hours(user,over_approval)
    user.designed_work_end_time = user.designed_work_end_time.change(month: over_approval.over_date.month, day: over_approval.over_date.day)
    over_work_hour = over_approval.scheduled_over_time_out - user.designed_work_end_time
    return over_work_hour/60/60
  end
end
