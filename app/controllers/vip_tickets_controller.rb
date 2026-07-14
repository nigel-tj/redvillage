class VipTicketsController < ApplicationController
    before_action :authenticate_user!, only: [:create]
    def index
    @qr_vip_tickets = RQRCode::QRCode.new("http://redvillage.herokuapp.com/events/1/vip_tickets",:size => 8).to_img.resize(200, 200).to_data_url
    
        
        
    end
    def create
        if current_user 
          @event = Event.find_by_id(params[:event_id])
          
            @event.vip_tickets.create({user_id: current_user.id})
             flash[:notice] = "Ticket has been Sent to your facebook photo : "
             redirect_to root_path    
        else
             flash[:success] = 'ticket has been booked already'
            redirect_to events_path
         
          #flash[:warning] = 'you have liked this qwatos before'
         # redirect_to qwatos_path
          #render js:  'alert(\'Your like cannot be saved.\');'
        end
        
      end
end
