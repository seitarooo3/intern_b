class OverApprovalsController < ApplicationController
  before_action :admin_user_true, only: [:create, :sup_update, :show]
  
  # 残業申請を新規or更新するメソッド
  def create
    @user = current_user
    
    # 残業申請済みであればupdate,新規残業申請であればcreateされるように条件分岐
    if OverApproval.find_by(over_date: over_approval_params[:over_date]).nil?
      
      @over_approval = OverApproval.new(over_approval_params)
      
      # changeメソッドで日付を正しくしたものを取り出したものをtime_outに格納するメソッド呼び出し
      set_date_to_over_date(@over_approval)
      
      if true == @over_approval.save(over_approval_params)
        flash[:success] = "残業申請しました。"
        redirect_to user_url(@user)
      else
        flash.now[:danger] = 'エラーが発生しました。'
        redirect_to user_url(@user)
      end

    else
      # すでに残業申請済みのレコードを変数@over_approvalに格納
      @over_approval = OverApproval.find_by(over_date: over_approval_params[:over_date])
      # 一旦paramsの値でDBを更新
      if true == @over_approval.update_attributes(over_approval_params)
        # changeメソッドで日付を正しくしたものを取り出したものをtime_outに格納するメソッド呼び出し
        @over_approval.update_attribute(:scheduled_over_time_out, set_date_to_over_date(@over_approval))
        flash[:success] = "残業申請しました。"
        redirect_to user_url(@user)
      else
        flash.now[:danger] = 'エラーが発生しました。'
        redirect_to user_url(@user)
      end
      
    end
    
  end
  
  def sup_update
    @user = current_user
    @over_applyings = OverApproval.where(over_approval_status: 2, over_approver_id: current_user.id)
    
    over_applying_users_ids = []
    @over_applyings.each do |applying|
      over_applying_users_ids.push(applying.user_id)
    end
    
    @over_applying_users = User.where(id: over_applying_users_ids)
    
    over_approvals_params.each do |id, item|
      over_approval = OverApproval.find(id)
      # チェックがtrueのレコードのみ更新
      if item[:checked_confirm] == "true"
        over_approval.update_attributes(item)
        flash[:success] = '残業申請を承認/否認しました。'
      else
        # flash[:success] = '変更にチェックされていない為、残業申請は更新しておりません。'
      end
    end
    
    
    redirect_to user_url(@user)
  
  end
  
  
  def set_date_to_over_date(over_approval)
    # 残業申請時間（終了予定時刻/scheduled_over_time）の"日付"を残業申請日（work_date）に合わせる
    over_approval.scheduled_over_time_out = over_approval.scheduled_over_time_out.change(day: over_approval.over_date.day)
    
    # 翌日換算フラグが"true"なら残業申請時間（終了予定時刻/scheduled_over_time）の"日付"を+1日
    if "true" == over_approval.checked_next_day
        over_approval.scheduled_over_time_out = over_approval.scheduled_over_time_out + 1.day
    end
    
    return over_approval.scheduled_over_time_out
    
  end

    private

      def over_approval_params
        params.permit(over_approval: [:user_id, :over_approver_id, :over_date, :scheduled_over_time_out, :checked_next_day, :over_approval_status, :note])[:over_approval]
      end
      
      def over_approvals_params
        params.permit(over_approvals: [:checked_confirm, :over_approval_status])[:over_approvals]
      end
      
      def admin_user_true
        if true == current_user.admin?
          flash[:danger] = "管理者は利用できません。"
          redirect_to(root_url)
        end
      end

end
