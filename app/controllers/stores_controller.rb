class StoresController < ApplicationController
  def index
    @stores = Store.all
    @banners = MainBanner.all
  end

  def new
    @store = Store.new
    render :layout => 'admin'
  end

  def show
  end

  def create
  end

  def update
  end

  def activate
  end

  def deactivate
  end
end
