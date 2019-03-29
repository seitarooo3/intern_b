module WorksHelper
  
  def format_basic_time(datetime)
    format("%.2f", ((datetime.hour * 60) + datetime.min)/60.0)
  end
  
  def working_hours(time_in, time_out)
    format("%.2f", (((time_out - time_in) / 60) / 60.0))
  end
  
  def working_hours_sum(seconds)
    format("%.2f", seconds / 60 / 60.0)
  end
  
  def works_check?
    result_works_check = true
    works_params.each do |id, item|
      
      if item[:time_in].blank? && item[:time_out].blank?
        next
      elsif item[:time_in].blank? || item[:time_out].blank?
        result_works_check = false
        break
      elsif item[:time_in] > item[:time_out]
        result_works_check = false
        break
      end
    end
  end
  
end
