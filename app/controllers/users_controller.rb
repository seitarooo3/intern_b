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
  
    private

      def user_params
        params.require(:user).permit(:name, :email, :dep, :password, :password_confirmation)
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
      if @user != current_user && false == current_user.admin?
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
