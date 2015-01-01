class SitesController < ApplicationController
  before_filter :login_required
  
  def index
    @sites = Site.paginate :page => params[:page], :order  => "last_ok ASC"
    
    respond_to do |format|
      format.html
      format.js {
        render :update do |page|
          page.replace "results", :partial => "list"
        end
      }
    end
  end
  
  def new
    @site = Site.new
  end
  
  def create
    @site = Site.new(params[:site])
    if @site.save
      redirect_to(:action => "index")
    else
      render(:action => "new")
    end
  end
  
  def edit
    @site = Site.find(params[:id])
  end
  
  def update
    @site = Site.find(params[:id])
    if @site.update_attributes(params[:site])
      flash[:notice] = "Site #{@site.name} updated"
      redirect_to :action => "index"
    else
      render :action => "edit"
    end
  end
  
  def clean_errors
    Site.transaction do
      Site.find(:all).each { |e|
        e.last_error = nil
        e.last_ok = true
        e.save
      }
    end
    flash[:notice] = "Cleaned all errors"
    redirect_to(:action => "index")
  end
  
  def destroy
    @site = Site.find(params[:id])
    
    if @site.destroy then
      flash[:notice] = "Site #{@site.name} deleted"
    else
      flash[:notice] = "Site #{@site.name} could not be deleted"
    end
    redirect_to(:action => "index")
  end
end