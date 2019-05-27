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
  
  # 更新対象であるにも関わらず、不正なデータが格納されている場合、falseを返す
  def works_check?
    result_works_check = true
    works_params.each do |id, item|
      work = Work.find(id)
      
      # 出勤時間がブランクかつ退勤時間がブランクかつ承認者がブランクであれば、更新対象ではないためnextで次のidを精査させる
      if item[:time_in].blank? && item[:time_out].blank? && item[:work_change_approver_id].blank?
        next
      
      # 出勤時間もしくは退勤時間のいずれかがブランクであればfalse + ただし、今日以外の場合
      elsif item[:time_in].blank? || item[:time_out].blank?
        
        if Date.today.to_s != item[:work_date]
          result_works_check = false
          break
        end
        
      # 出勤退勤どちらも入力はされているが、承認者が設定されていなければfalse　＋　ただし変更していないのは除く
      elsif item[:time_in].present? && item[:time_out].present? && item[:work_change_approver_id].blank?
        
        # 新規の場合（workモデルに出勤時間、退勤時間、承認者が設定されていない場合）
        if work.time_in.nil? && work.time_out.nil? && work.work_change_approver_id.nil?
          result_works_check = false
          break
        # 更新の場合
        elsif work.time_in.strftime("%H:%M") != item[:time_in].to_s[0..4] || work.time_out.strftime("%H:%M") != item[:time_out].to_s[0..4]
          result_works_check = false
          break
        end
      
      # 翌日フラグが立っていない場合に、退勤時間より出勤時間の時刻が遅ければfalse
      elsif item[:time_in] > item[:time_out] && "false" == item[:checked_next_day]
        result_works_check = false
        break
      end
    end
    return result_works_check
  end
  
end
