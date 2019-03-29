module UsersHelper
  
  
  
  def prev_month
    user_path(params:{current_date: @today.prev_month})
  end
  
  def next_month
    user_path(params:{current_date: @today.next_month})
  end
  
end
