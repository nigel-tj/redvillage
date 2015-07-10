class EventsController < ApplicationController
    before_filter :authenticate_user!
   
      def index
        @events = Event.all
        
      end
    
      def new
        @event= Event.new
        
      end
      def create 
        @event = Event.create(event_params)
        
        if @event.save
          flash[:notice] = "The event has been saved"
          redirect_to root_path
          
        else
          flash[:alert] = "The event has not been created"
          render "new"
        end
        
      end
      def show
        @event = Event.find(params[:id]) 
        @events = Event.all  
      end
      def edit
        @event = Event.find(params[:id])
      end
    
        def update
        @event = Event.find(params[:id])
        if @artist.update(event_params)
          flash[:notice] = "Event has been updated."
    
        #   redirect_to admin_panel_index_path
        
          
        end
        
      end
      private
      def event_params
          params.require(:event).permit(:name , :image_link)
          
        end
end