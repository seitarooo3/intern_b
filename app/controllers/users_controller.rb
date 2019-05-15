class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update, :show]
  before_action :admin_user,     only: [:destroy, :edit_basic_info, :update_basic_info, :index]
  
  def show
    @user = User.find(params[:id])
    
    if params[:current_date].nil?
      @today = Date.today
    else
      @today = Date.parse(params[:current_date])
    end
    
    # 表示月の出勤情報（work_date）をuserが所有しているかどうかを確認し、
    # 無ければ空データ作成、有れば表示させるメソッド
    @work = @user.works.find_by(work_date: @today)
    
    if @work.nil?
      # 月間勤怠情報の空データを作成
      (@today.beginning_of_month..@today.end_of_month).each do |i|
        record = @user.works.build(work_date: i)
        record.save
        @work = @user.works.find_by(work_date: @today)
      end
    end
    
    # 該当ユーザーに紐づく表示月の勤怠情報を@worksに格納
    @works = @user.works.where('work_date >= ? and work_date <= ?', @today.beginning_of_month, @today.end_of_month).order('work_date')
    
    # 勤務日数を格納
    @work_sum = @works.where.not(time_in: nil).count
    
    # 該当ユーザーの表示月の申請状況を格納
    @month_approval = @user.month_approvals.find_by(work_month: @today.beginning_of_month)
    
    # 該当ユーザーの表示月の月別申請がなければ、表示用の空データを作成
    if @month_approval.nil?
      record = @user.month_approvals.build(work_month: @today.beginning_of_month)
      record.save
      @month_approval = @user.month_approvals.find_by(work_month: @today.beginning_of_month)
    end

    # TBLから承認者がログインユーザー且つ月別勤怠申請中のデータを格納
    @month_applyings = MonthApproval.where(month_approval_status: 2).where(month_approver_id: current_user.id)
    
    month_applying_users_ids = []
    @month_applyings.each do |applying|
      month_applying_users_ids.push(applying.user_id)
    end
    
    @month_applying_users = User.where(id: month_applying_users_ids)
    
    # 残業申請用オブジェクトの作成
    @over_approval = OverApproval.new
    
    # TBLから承認者がログインユーザー且つ残業申請中のデータを格納
    @over_applyings = OverApproval.where(over_approval_status: 2).where(over_approver_id: current_user.id)
    
    over_applying_users_ids = []
    @over_applyings.each do |applying|
      over_applying_users_ids.push(applying.user_id)
    end
    
    @over_applying_users = User.where(id: over_applying_users_ids)
    
    @sup_users = User.where(sup: true)
    
    @work_changings = Work.where(work_change_status: 2).where(work_change_approver_id: current_user.id)
    
    work_changing_users_ids = []
    @work_changings.each do |applying|
      work_changing_users_ids.push(applying.user_id)
    end
    
    @work_changing_users = User.where(id: work_changing_users_ids)
    
  end
  
  def new
    # 新規作成画面で新規ユーザーの箱を作成するイメージ
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if true == @user.save
      # 新規作成後、ログイン
      redirect_to login_url
    else
      flash.now[:danger] = 'エラーが発生しました。'
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if true == @user.update_attributes(user_params)
      flash[:success] = "更新完了しました。"
      redirect_to @user
    else
      flash.now[:danger] = 'エラーが発生しました。'
      render 'edit'
    end
  end
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def index_time_in
    today = Date.current
    @time_in_works = Work.where(work_date: today, time_out: nil)
    @time_in_works = @time_in_works.where.not(time_in: nil)
    
    time_in_users_ids = []
    @time_in_works.each do |works|
      time_in_users_ids.push(works.user_id)
    end
    
    @time_in_users = User.where(id: time_in_users_ids)
    
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "削除しました。"
    redirect_to users_url
  end
  
  def edit_basic_info
    @user = User.find(params[:id])
  end
  
  def update_basic_info
    @user = User.find(params[:id])
    if @user.update_attributes(basic_info_params)
      flash[:success] = "基本情報を更新しました。"
      redirect_to @user   
    else
      render 'edit_basic_info'
    end
    
  end
  
  def import
    # fileはtmpに自動で一時保存される
    User.import(params[:file])
    redirect_to users_url, notice: "ユーザーを追加しました。"
  end
  
    private

      def user_params
        params.require(:user).permit(:name, :email, :dep, :password, :password_confirmation, :designed_time_in, :designed_time_out, :card_id, :employee_id)
      end
      
      def basic_info_params
        params.require(:user).permit(:basic_time, :work_time)
      end

    # beforeアクション

    # ログイン済みユーザーか確認
    def logged_in_user
      unless logged_in?
        flash[:danger] = "ログインしてください。"
        redirect_to login_url
      end
    end
    
    def correct_user
      @user = User.find(params[:id])
      if @user != current_user && false == current_user.admin? && false == current_user.sup?
        flash[:danger] = "権限がありません。"
        redirect_to(root_url)
      end
    end
    
    def admin_user
      if false == current_user.admin?
        flash[:danger] = "管理者権限がありません。"
        redirect_to(root_url)
      end
    end
    
end
