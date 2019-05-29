class WorksController < ApplicationController
  before_action :admin_user_true, only: [:create, :edit, :update, :sup_update, :work_log_index, :index_works]
  
  def create
    @user = User.find(params[:user_id])
    @work = @user.works.find_by(work_date: Date.today)
    
    if @work.time_in.nil?
      @work.update_attributes(time_in: Time.new(
      Time.now.year,
      Time.now.month,
      Time.now.day,
      Time.now.hour,
      Time.now.min,)
    )
    
    # work_logsに格納
    @work_log = WorkLog.new(user_id: @work.user_id,
    user_name: @user.name,
    work_date: @work.work_date,
    pre_time_in: @work.time_in
    )
    
    @work_log.save
    
    flash[:info] = 'おはようございます。'
    
    
    elsif @work.time_out.nil?
      @work.update_attributes(time_out: Time.new(
      Time.now.year,
      Time.now.month,
      Time.now.day,
      Time.now.hour,
      Time.now.min, 0)
      )
    
    # work_logsTBLに退勤時間を格納
    @work_log = WorkLog.find_by(work_date: @work.work_date)
    @work_log.update_attribute(:pre_time_out, @work.time_out)
    
    flash[:info] = 'お疲れ様でした。'
    else
      flash[:danger] = 'トラブルがあり、登録出来ませんでした。'
    end
    
    redirect_to @user
  end
  
  def edit
    @user = User.find(params[:user_id])
    @work = @user.works.find_by(work_date: Date.today)
    # 「勤怠を編集」ボタン押下時に引数に指定した日付（user_helperのcurrent_date）がURLに含まれているため、そこから値を取得
    @today = Date.parse(params[:date])
    @works = @user.works.where('work_date >= ? and work_date <= ?', @today.beginning_of_month, @today.end_of_month).order('work_date')
    @sup_users = User.where(superior: true)
    @sup_users = @sup_users.where.not(id: @user.id)
  end
  
  def update
    @user = User.find(params[:user_id])
    
    # 申請情報に誤りがないか、ヘルパー先でチェック
    if works_check?
      works_params.each do |id, item|
        work = Work.find(id)
        
        # 更新対象の抽出（申請情報の内、承認者が設定されている且つ出勤・退勤時刻いずれもが格納されたレコードのみ更新。）
        if item[:work_change_approver_id].present? && item[:time_in].present? && item[:time_out].present?
          
          # 新規の場合
          if work.time_in.nil? && work.time_out.nil? && work.work_change_approver_id.nil?
            work.update_attributes(item)
            work.update(time_in: set_date_to_time_in(work), time_out: set_date_to_time_out(work))
            
            @work_log = WorkLog.new(user_id: work.user_id,
            user_name: @user.name,
            work_date: work.work_date,
            post_time_in: work.time_in,
            post_time_out: work.time_out
            )
            
            @work_log.save
            
          # 更新の場合（出勤時間、退勤時間、承認者のいずれかに変更がある場合）
          elsif work.time_in.strftime("%H:%M") != item[:time_in].to_s[0..4] || work.time_out.strftime("%H:%M") != item[:time_out].to_s[0..4] || work.work_change_approver_id != item[:work_change_approver_id].to_i
            work.update_attributes(item)
            work.update(time_in: set_date_to_time_in(work), time_out: set_date_to_time_out(work))
            @work_log = WorkLog.find_by(work_date: work.work_date)
            @work_log.update(post_time_in: work.time_in, post_time_out: work.time_out, work_change_approved?: false)
          end
       
        end
        
        flash[:info] = '勤怠変更申請が完了しました。'
        
      end
    else
        flash[:danger] = 'エラーが発生しました。'
    end
    redirect_to user_url(@user, params:{current_date: params[:date]})
  end
  
   # 上長による勤怠情報変更申請の承認
  def sup_update
    
    # worksTBLの更新（別アクション？）
    @user = current_user
    @work_changings = Work.where(work_change_status: 2, work_change_approver_id: current_user.id)
    
    work_changing_users_ids = []
    @work_changings.each do |applying|
      work_changing_users_ids.push(applying.user_id)
    end
    
    @work_changing_users = User.where(id: work_changing_users_ids)
    
    works_params.each do |id, item|
      work = Work.find(id)
      # チェックがtrueのレコードのみ更新
      if item[:checked_confirm] == "true"
        work.update_attributes(item)
        
        # ログを更新
        if item[:work_change_status] == "承認"
          sup_user = User.find(work.work_change_approver_id)
          @work_log = WorkLog.find_by(work_date: work.work_date)
          @work_log.update(work_change_approved?: true, work_change_approver_id: work.work_change_approver_id, work_change_approver_name: sup_user.name)
        end
        flash[:success] = '勤怠変更申請を承認/否認しました。'
      else
        # flash[:success] = '変更にチェックされていない為、勤怠変更申請を更新しておりません。'
      end
    end
    
    redirect_to user_url(@user)
    
  end
  
  # 勤怠ログ表示機能
  def work_log_index
    unless params[:year].nil? && params[:month].nil?
      timea = Time.new(params[:year], params[:month])
      timeb = timea.end_of_month
      user = current_user
      @work_logs = WorkLog.search(user, timea, timeb)
    end
  end
  
  # 出勤_退勤時刻を日にち合わせる＆翌日換算フラグ処理用アクション
  def set_date_to_time_in(work)
    
    # time_inの"日付"をwork_dateに合わせる
    work.time_in = work.time_in.change(day: work.work_date.day)
    return work.time_in
  end
  
  def set_date_to_time_out(work)
    work.time_out = work.time_out.change(day: work.work_date.day)
    
    # 翌日換算フラグが"true"ならtime_outの"日付"を+1日
    if "true" == work.checked_next_day
      work.time_out = work.time_out + 1.day
    end
    
    return work.time_out
  end
  
  # csv出力
  def index_works
    @user = current_user
    
    # 以下のparams[:current_date]はURL上のparamsではなく、CSV出力ボタンから受け渡されたparams
    if params[:current_date].nil?
      @today = Date.today
    else
      @today = Date.parse(params[:current_date])
    end
    
    # 表示月の出勤情報（work_date）をuserが所有しているかどうかを確認し、
    # 無ければ空データ作成、有れば表示させるメソッド
    @work = @user.works.find_by(work_date: @today)
    @works = @user.works.where('work_date >= ? and work_date <= ?', @today.beginning_of_month, @today.end_of_month).order('work_date')
    puts "せいのすけ"
    puts @today
    puts @work.work_date
    
    respond_to do |format|
      format.html do
          #html用の処理を書く
      end 
      format.csv do
          #csv用の処理を書く
      end
    end
  end
  
  private
    def works_params
      params.permit(works: [:work_date, :time_in, :time_out, :note, :work_change_approver_id, :checked_next_day, :checked_confirm, :work_change_status])[:works]
    end
    
    def admin_user_true
      if true == current_user.admin?
        flash[:danger] = "管理者は利用できません。"
        redirect_to(root_url)
      end
    end
  
end
