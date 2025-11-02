class EventsController < ApplicationController
  include RoleBasedAccess
  
  before_action :authenticate_user!, except: [:index, :show]
  before_action :require_admin_or_dj, only: [:new, :create, :update, :edit, :destroy]
  layout "admin", only: [:new, :create, :update,  :admin_all_events, :admin_show_event, :edit]
  
  private
  
  def require_admin_or_dj
    unless current_user&.admin? || current_user&.dj?
      flash[:alert] = "You need to be an admin or DJ to perform this action."
      redirect_to root_path
    end
  end
  def index
    @events = Event.order('created_at DESC')  
  end
  def admin_all_events
    @events = Event.order('created_at DESC')
  end
  
  def new
    @event= Event.new
  end
  
  def create 
    @event = Event.create(event_params)
    
    if @event.save
      flash[:notice] = "The event has been saved"
      redirect_to "/admin_all_events"  
    else
      flash[:alert] = "The event has not been created"
      render "new"
    end
    
  end

  def show
    @event = Event.find(params[:id]) 
    @events = Event.all  
  end

  def admin_show_event
    @event = Event.find(params[:id]) 
    @events = Event.all  
  end

  def edit
    @event = Event.find(params[:id])
  end
  
  def update
    @event = Event.find(params[:id])
    if @event.update(event_params)
      flash[:notice] = "Event has been updated."
      redirect_to admin_all_events_path
    else
      flash[:alert] = "Event could not be updated."
      render "edit"
    end  
  end
  
  def destroy
    @event = Event.find(params[:id])
    if @event.destroy
      flash[:notice] = "Event has been deleted."
    else
      flash[:alert] = "Event could not be deleted."
    end
    redirect_to admin_all_events_path
  end

  private
  def event_params
    params.require(:event).permit(:name, :image, :summary, :date, :start_time, :venue, :featured, :standard_ticket_price, :vip_ticket_price, :currency)  
  end

end
