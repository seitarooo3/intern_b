class BranchesController < ApplicationController
  def index
    @branches = Branch.all
    @branch = Branch.new
  end
  
  def new
    @branch = Branch.new
  end
  
  def create
    @branch = Branch.new(branch_params)
    
    if true == @branch.save
      @branch.save
      flash[:success] = "拠点を新規作成しました。"
      redirect_to branches_url
    else
      flash[:danger] = 'エラーが発生しました。'
      redirect_to '/branches'
    end
    
  end
  
  def edit
    @branch = Branch.find(params[:id])
  end
  
  def update
    @branch = Branch.find(params[:id])
    if true == @branch.update_attributes(branch_params)
      flash[:success] = "更新完了しました。"
      redirect_to branches_url
    else
      flash[:danger] = 'エラーが発生しました。'
      render 'edit'
    end
  end
  
  def destroy
    Branch.find(params[:id]).destroy
    flash[:success] = "削除しました。"
    redirect_to branches_url
  end

    private
      def branch_params
        params.require(:branch).permit(:branch_id, :branch_name, :branch_status)
      end
      

end
