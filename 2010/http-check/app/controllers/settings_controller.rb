class SettingsController < ApplicationController
  before_filter :login_required
  
  def index
    @settings = Setting.paginate :page => params[:page]
    
    respond_to do |format|
      format.html
      format.js {
        render :update do |page|
          page.replace "results", :partial => "list"
        end
      }
    end
  end
  
  def edit
    @setting = Setting.find(params[:id])
  end
  
  def update
    @setting = Setting.find(params[:id])
    
    if @setting.update_attributes(params[:setting])
      flash[:notice] = "Setting #{@setting.name} updated"
      redirect_to :action => "index"
    else
      render :action => "edit"
    end
  end
end
