class WorksController < ApplicationController
  def create
    @user = User.find(params[:user_id])
    @work = @user.works.find_by(work_date: Date.today)
    
    if @work.time_in.nil?
      @work.update_attributes(time_in: Time.new(
      Time.now.year,
      Time.now.month,
      Time.now.day,
      Time.now.hour,
      Time.now.min, 0)
    )
    flash[:info] = 'おはようございます。'
    
    elsif @work.time_out.nil?
      @work.update_attributes(time_out: Time.new(
      Time.now.year,
      Time.now.month,
      Time.now.day,
      Time.now.hour,
      Time.now.min, 0)
      )
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
    
  end
  
  def update
    @user = User.find(params[:user_id])
    if works_check?
      works_params.each do |id, item|
        work = Work.find(id)
        if work.work_date > Date.today
          flash[:danger] = 'エラーが発生しました。'
        else
          work.update_attributes(item)
          flash[:info] = '更新が完了しました。'
        end
      end
    else
        flash[:danger] = 'エラーが発生しました。'
    end
    redirect_to user_url(@user, params:{current_date: params[:date]})
  end
  
  private
    def works_params
      params.permit(works: [:time_in, :time_out, :note])[:works]
    end
  
  
end
