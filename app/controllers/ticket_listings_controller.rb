class TicketListingsController < ApplicationController
  layout :determine_layout
  
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_ticket_listing, only: [:show, :edit, :update, :destroy]
  before_action :ensure_ownership, only: [:edit, :update, :destroy]
  
  def determine_layout
    case action_name
    when 'index', 'show'
      'new_look_layout'  # Use front-end layout for public pages
    else
      'admin'  # Use admin layout for authenticated actions
    end
  end
  
  def index
    @event = params[:event_id].present? ? Event.find(params[:event_id]) : nil
    @ticket_type = params[:ticket_type].presence
    
    @ticket_listings = TicketListing.includes(:user, :event)
    
    if @event
      @ticket_listings = @ticket_listings.by_event(@event.id)
    end
    
    if @ticket_type
      @ticket_listings = @ticket_listings.by_type(@ticket_type)
    end
    
    # Filter by status - show available and pending by default
    status_filter = params[:status].presence || 'available'
    @ticket_listings = @ticket_listings.where(status: status_filter) if %w[available sold pending expired].include?(status_filter)
    
    # Search by event name or description
    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @ticket_listings = @ticket_listings.joins(:event)
                                        .where("events.name ILIKE ? OR ticket_listings.description ILIKE ?", 
                                               search_term, search_term)
    end
    
    # Order by price or date
    case params[:sort]
    when 'price_asc'
      @ticket_listings = @ticket_listings.order(:price)
    when 'price_desc'
      @ticket_listings = @ticket_listings.order(price: :desc)
    when 'newest'
      @ticket_listings = @ticket_listings.order(created_at: :desc)
    when 'oldest'
      @ticket_listings = @ticket_listings.order(:created_at)
    else
      @ticket_listings = @ticket_listings.order(created_at: :desc)
    end
    
    # Only show available tickets by default for public view
    # Admins can see all tickets, regular users see only available ones
    unless current_user&.admin?
      @ticket_listings = @ticket_listings.for_sale
    end
    
    @events = Event.order(:date).limit(20) if @event.nil?
  end
  
  def show
    @event = @ticket_listing.event
    @seller = @ticket_listing.user
  end
  
  def new
    @event = Event.find(params[:event_id]) if params[:event_id].present?
    @ticket_listing = current_user.ticket_listings.build
    # Show upcoming events first, but include past events too for flexibility
    @events = Event.order(date: :asc)
    
    # Pre-fill with event data if available
    if @event
      @ticket_listing.event = @event
      @ticket_listing.ticket_type = params[:ticket_type] || 'standard'
      @ticket_listing.price = @event.send("#{@ticket_listing.ticket_type}_ticket_price") || 0
      @ticket_listing.original_price = @ticket_listing.price
      @ticket_listing.currency = @event.currency || 'USD'
    end
  end
  
  def create
    @ticket_listing = current_user.ticket_listings.build(ticket_listing_params)
    
    if @ticket_listing.save
      flash[:success] = "🎉 Your ticket listing has been created successfully! It's now live on the marketplace."
      redirect_to ticket_listing_path(@ticket_listing), notice: 'Ticket listing created successfully.'
    else
      @event = @ticket_listing.event
      @events = Event.order(date: :asc).where("date >= ?", Date.today)
      flash.now[:error] = "Please fix the errors below to create your listing."
      render :new, status: :unprocessable_entity
    end
  end
  
  def edit
    @event = @ticket_listing.event
    @events = Event.order(date: :asc)
  end
  
  def update
    if @ticket_listing.update(ticket_listing_params)
      flash[:success] = "✨ Your ticket listing has been updated!"
      redirect_to ticket_listing_path(@ticket_listing), notice: 'Ticket listing updated successfully.'
    else
      @event = @ticket_listing.event
      @events = Event.order(date: :asc)
      flash.now[:error] = "Please fix the errors below."
      render :edit, status: :unprocessable_entity
    end
  end
  
  def destroy
    @ticket_listing.destroy
    flash[:success] = "Ticket listing removed successfully."
    redirect_to my_tickets_path, notice: 'Ticket listing deleted successfully.'
  end
  
  def my_tickets
    @ticket_listings = current_user.ticket_listings
                                  .includes(:event)
                                  .order(created_at: :desc)
    @available_count = @ticket_listings.available.count
    @sold_count = @ticket_listings.where(status: 'sold').count
    @total_revenue = @ticket_listings.where(status: 'sold')
                                    .sum { |t| t.price * t.sold_quantity }
  end
  
  private
  
  def set_ticket_listing
    @ticket_listing = TicketListing.find(params[:id])
  end
  
  def ensure_ownership
    unless @ticket_listing.user == current_user || current_user&.admin?
      flash[:error] = "You don't have permission to perform this action."
      redirect_to ticket_listings_path
    end
  end
  
  def ticket_listing_params
    params.require(:ticket_listing).permit(:event_id, :ticket_type, :price, :quantity, 
                                           :description, :status, :original_price, :currency)
  end
end

