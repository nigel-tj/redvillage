class StoreDashboardsController < ApplicationController
  before_action :set_store
  before_action :authenticate_user!
  before_action :ensure_store_owner
  
  def show
    @date_range = params[:date_range] || '30' # days
    @start_date = @date_range.to_i.days.ago.beginning_of_day
    @end_date = Time.current
    
    # Overall Statistics
    @stats = {
      total_products: @store.products.count,
      active_products: @store.products.active.count,
      out_of_stock: @store.products.where(status: 'out_of_stock').count,
      low_stock: @store.products.where('inventory_quantity > 0 AND inventory_quantity <= 10').count,
      total_orders: @store.orders.count,
      pending_orders: @store.orders.pending.count,
      completed_orders: @store.orders.completed.count,
      total_revenue: @store.orders.completed.sum(:total_amount),
      total_customers: @store.orders.select(:user_id).distinct.count,
      average_order_value: @store.orders.completed.any? ? (@store.orders.completed.sum(:total_amount) / @store.orders.completed.count) : 0,
      conversion_rate: calculate_conversion_rate
    }
    
    # Revenue Statistics
    @revenue_stats = {
      today: revenue_for_period(Time.current.beginning_of_day, Time.current),
      this_week: revenue_for_period(1.week.ago.beginning_of_week, Time.current),
      this_month: revenue_for_period(1.month.ago.beginning_of_month, Time.current),
      last_month: revenue_for_period(2.months.ago.beginning_of_month, 1.month.ago.end_of_month),
      all_time: @store.orders.completed.sum(:total_amount)
    }
    
    # Order Statistics by Status
    @order_stats_by_status = {
      pending: @store.orders.pending.count,
      processing: @store.orders.where(status: 'processing').count,
      shipped: @store.orders.where(status: 'shipped').count,
      delivered: @store.orders.where(status: 'delivered').count,
      cancelled: @store.orders.where(status: 'cancelled').count
    }
    
    # Revenue Trends (last 30 days)
    @revenue_trends = calculate_revenue_trends(30)
    
    # Top Products by Sales
    @top_products = @store.products
                          .joins(:order_items)
                          .joins('JOIN orders ON order_items.order_id = orders.id')
                          .where('orders.status IN (?)', ['processing', 'shipped', 'delivered'])
                          .group('products.id')
                          .select('products.*, SUM(order_items.quantity) as total_sold, SUM(order_items.total_price) as total_revenue')
                          .order('total_sold DESC')
                          .limit(10)
    
    # Recent Orders
    @recent_orders = @store.orders.includes(:user, :order_items).order(created_at: :desc).limit(10)
    
    # Low Stock Products
    @low_stock_products = @store.products.where('inventory_quantity > 0 AND inventory_quantity <= 10')
                                       .order(:inventory_quantity)
                                       .limit(10)
    
    # Product Performance
    @product_performance = calculate_product_performance
    
    # Sales by Product Category (if categories exist later)
    @sales_by_product = @store.order_items
                             .joins(:order, :product)
                             .where('orders.status IN (?)', ['processing', 'shipped', 'delivered'])
                             .group('products.name')
                             .select('products.name, SUM(order_items.quantity) as quantity_sold, SUM(order_items.total_price) as revenue')
                             .order('revenue DESC')
                             .limit(10)
    
    # Customer Statistics
    @customer_stats = {
      total_customers: @store.orders.select(:user_id).distinct.count,
      repeat_customers: calculate_repeat_customers,
      new_customers_this_month: @store.orders.where('created_at >= ?', 1.month.ago).select(:user_id).distinct.count
    }
    
    render layout: 'admin'
  end
  
  private
  
  def set_store
    @store = Store.friendly.find(params[:store_id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "Store not found."
    redirect_to stores_path
  end
  
  def ensure_store_owner
    unless @store.owner?(current_user) || current_user.admin?
      flash[:alert] = "You don't have permission to access this dashboard."
      redirect_to @store
    end
  end
  
  def revenue_for_period(start_date, end_date)
    @store.orders
          .where(status: ['processing', 'shipped', 'delivered'])
          .where(created_at: start_date..end_date)
          .sum(:total_amount)
  end
  
  def calculate_revenue_trends(days)
    trends = []
    days.downto(0) do |i|
      date = i.days.ago
      start_of_day = date.beginning_of_day
      end_of_day = date.end_of_day
      
      revenue = revenue_for_period(start_of_day, end_of_day)
      orders = @store.orders.where(created_at: start_of_day..end_of_day).count
      
      trends << {
        date: date.strftime('%m/%d'),
        revenue: revenue,
        orders: orders,
        date_full: date.strftime('%Y-%m-%d')
      }
    end
    trends.reverse
  end
  
  def calculate_conversion_rate
    # Simple conversion rate: orders / unique visitors (using cart sessions as proxy)
    total_carts = @store.carts.count
    total_orders = @store.orders.count
    
    return 0 if total_carts.zero?
    ((total_orders.to_f / total_carts) * 100).round(2)
  end
  
  def calculate_product_performance
    @store.products.map do |product|
      sold_quantity = product.order_items.joins(:order)
                            .where('orders.status IN (?)', ['processing', 'shipped', 'delivered'])
                            .sum(:quantity)
      
      revenue = product.order_items.joins(:order)
                      .where('orders.status IN (?)', ['processing', 'shipped', 'delivered'])
                      .sum(:total_price)
      
      views = 0 # Could add view tracking later
      
      {
        product: product,
        sold_quantity: sold_quantity,
        revenue: revenue,
        views: views,
        conversion_rate: views > 0 ? ((sold_quantity.to_f / views) * 100).round(2) : 0
      }
    end.sort_by { |p| -p[:revenue] }
  end
  
  def calculate_repeat_customers
    customer_order_counts = @store.orders
                                   .group(:user_id)
                                   .count
    customer_order_counts.values.count { |count| count > 1 }
  end
end

