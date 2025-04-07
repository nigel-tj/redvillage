require 'rqrcode_png'  
class VisitorsController < ApplicationController
  #before_action :authenticate_user! #, except: [:index,:show, :vidoes, :social, :news, :portfolio,:gallery]
  layout "team_layout", only: [:team]
  layout "new_look_layout", only: [:index, :about_us, :event_new_look, :gallery, :top_dj, :schedule, :blog, :blog_details, :faq, :contact_us]
  def index
    @banners = MainBanner.where(:page => "home")
    @trends  = Feature.all
    @videos = Video.order('created_at DESC')
    @events = Event.order('date ASC').limit(4)
    # twiiter
        #@tweets = $twitter.search("UpperEchelon12June ", result_type: "recent").take(20)
    
    # @client = Instagram.client(:access_token  => '1052563623.1fb234f.99cb9eff244d48e8a71027ed63f6830f')
    # default_search = @client.tag_search('Redcupvillage')
    # @tag = default_search
    # @tag = @tag.first.name
    # @results = @client.tag_recent_media(@tag)
    # @graph = Koala::Facebook::API.new( '427969987356450|1BAAiHW4nnWkIL7NfhsI7pi5dD0')
    # @feed = @graph.get_connections("TheRedcupvillage", "posts",'type' => 'large')
    # @qr = RQRCode::QRCode.new("http://redvillage.herokuapp.com").to_img.resize(200, 200).to_data_url
    
    end

    def index_old
      @banners = MainBanner.where(:page => "home")
    @trends  = Feature.all
    @videos = Video.order('created_at DESC')
    end

    def videos
       @videos = Video.order('created_at DESC')
    end

    def team
    end

    def top_dj
    end
    
    def schedule
    end

    def event_new_look
    end

    def about_us
    end

    def blog
    end

    def blog_details
    end
    def faq
    end
    def contact_us
    end

    def social
       @tweets = $twitter.search("UpperEchelon12June ", result_type: "recent").take(20)
    end

    def news
      # @client = Instagram.client(:access_token  => '1052563623.1fb234f.99cb9eff244d48e8a71027ed63f6830f')
      #   default_search = @client.tag_search('Redcupvillage')
      #   @tag = default_search
      #   @tag = @tag.first.name
      #   @results = @client.tag_recent_media(@tag)
        @graph = Koala::Facebook::API.new( '427969987356450|1BAAiHW4nnWkIL7NfhsI7pi5dD0')
        @feed = @graph.get_connections("TheRedcupvillage", "posts",'type' => 'large')
        #@qr = RQRCode::QRCode.new("http://redvillage.herokuapp.com").to_img.resize(200, 200).to_data_url
        
    end
    def portfolio
        render :pdf => "public/docs/Proposal-template.pdf"
    end
    
    def gallery
      @galleries = Gallery.all
    end

end
