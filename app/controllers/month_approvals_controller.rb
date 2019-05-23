class MonthApprovalsController < ApplicationController
  before_action :admin_user_true, only: [:update, :sup_update ]
  
  def update
    @user = current_user
    
    # formでhiddenされた表示月を取得
    @today = Date.parse(params[:month_approval][:work_month])
    
    @month_approval = @user.month_approvals.find_by(work_month: @today.beginning_of_month)
    
    month_approver_name = params[:month_approval][:month_approver_id]
    sup_user = User.find_by(name: month_approver_name)
    
    if true == @month_approval.update(month_approver_id: sup_user.id, month_approval_status: 2)
      flash[:success] = "申請完了しました。"
      redirect_to @user      
    else
      flash.now[:danger] = 'エラーが発生しました。'
      redirect_to @user 
    end
  end
  
  def sup_update
   
    @user = current_user
    @month_applyings = MonthApproval.where(month_approval_status: 2, month_approver_id: current_user.id)
    
    applying_users_ids = []
    @month_applyings.each do |applying|
      applying_users_ids.push(applying.user_id)
    end
    
    @month_applying_users = User.where(id: applying_users_ids)
    
    month_approval_params.each do |id, item|
      month_approval = MonthApproval.find(id)
      # チェックがtrueのレコードのみ更新
      if item[:checked] == "true"
        month_approval.update_attributes(item)
        flash[:success] = '月別勤怠申請を承認/否認しました'
      else
        # flash[:success] = '変更にチェックされていない為、月別勤怠申請を更新しておりません。'
      end
    end
    
    redirect_to user_url(@user)
  
  end

    private

      def month_approval_params
        params.permit(month_approvals: [:month_approver_id, :work_month, :checked, :month_approval_status])[:month_approvals]
      end
      
      def admin_user_true
        if true == current_user.admin?
          flash[:danger] = "管理者は利用できません。"
          redirect_to(root_url)
        end
      end
  
end
