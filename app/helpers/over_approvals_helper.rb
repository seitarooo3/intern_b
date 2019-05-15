module OverApprovalsHelper
  
  def over_work_hours(user,over_approval)
    user.designed_time_out = user.designed_time_out.change(month: over_approval.over_date.month, day: over_approval.over_date.day)
    over_work_hour = over_approval.scheduled_over_time_out - user.designed_time_out
    return over_work_hour/60/60
  end
end
