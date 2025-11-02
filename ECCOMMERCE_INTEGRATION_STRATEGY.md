# E-Commerce Integration Strategy for RedVillage Multi-Store Marketplace

Based on the research from [Resolve Digital's Top 8 Rails Gems for eCommerce](https://www.resolvedigital.com/blog/8-best-ruby-on-rails-gems-for-ecommerce-applications), this document outlines a comprehensive strategy for integrating e-commerce capabilities into your multi-store marketplace.

## Current State Analysis

### ✅ Already Implemented
- **Simple Form** - Already in Gemfile ✓
- **Kaminari** - Already in Gemfile ✓
- Multi-store system with user ownership
- Ticket marketplace with pricing
- Basic currency support (USD default)

### ❌ Missing Critical Components
- **Payment Processing** - No payment gateway integration
- **Shipping** - No shipping calculations or carrier integration
- **Order Management** - No order system
- **Product Catalog** - Stores exist but no products
- **Cart/Checkout** - No shopping cart functionality
- **Inventory Management** - No stock tracking

---

## Recommended Integration Strategy

### Phase 1: Core E-Commerce Foundation (Weeks 1-2)

#### 1.1 Payment Processing - **HIGH PRIORITY** 🔴

**Gems to Add:**
```ruby
# Primary payment gateway
gem 'stripe', '~> 10.0'

# Payment abstraction layer (for multiple gateways)
gem 'activemerchant', '~> 1.130'
```

**Why Stripe First?**
- Most popular Rails payment gem
- Excellent documentation
- Supports multiple payment methods
- Built-in fraud protection
- Easy subscription handling

**Why ActiveMerchant?**
- Abstraction layer for multiple payment gateways
- If you need PayPal, Square, etc. later
- Unified API for different providers

**Implementation Tasks:**
1. Add Stripe gem and run `bundle install`
2. Create `Order` model with:
   - `belongs_to :store`
   - `belongs_to :user` (customer)
   - Payment status tracking
   - Total amount, currency
   - Shipping address
3. Create `OrderItem` model for line items
4. Create `Payment` model to track transactions
5. Set up Stripe webhooks for payment confirmations
6. Create checkout controller
7. Add Stripe API keys to environment variables

**Database Schema:**
```ruby
# Orders
- store_id (references)
- user_id (references)
- status (pending, processing, shipped, delivered, cancelled)
- total_amount (decimal)
- currency (string)
- payment_status (pending, paid, failed, refunded)
- shipping_address (text)
- billing_address (text)
- stripe_payment_intent_id (string)

# Order Items
- order_id (references)
- product_id (references) # Will create Product model
- quantity (integer)
- unit_price (decimal)
- total_price (decimal)
```

---

#### 1.2 Product Catalog System

**Implementation Tasks:**
1. Create `Product` model:
   ```ruby
   belongs_to :store
   has_many :order_items
   has_many :product_images
   ```
2. Add product fields:
   - name, description, SKU
   - price, compare_at_price
   - inventory_quantity
   - status (active, inactive, out_of_stock)
   - weight, dimensions (for shipping)
3. Create product CRUD controllers
4. Add product views for stores
5. Implement product search and filtering

---

#### 1.3 Shopping Cart System

**Implementation Tasks:**
1. Create `Cart` model (session-based initially):
   - Store cart items in session or database
   - Link to user if signed in
2. Create `CartItem` model:
   - product_id, quantity
3. Create CartController:
   - Add to cart
   - Update quantities
   - Remove items
   - View cart
4. Add cart icon/badge to navigation

---

### Phase 2: Shipping & Fulfillment (Weeks 3-4)

#### 2.1 Shipping Integration - **MEDIUM PRIORITY** 🟡

**Gem to Add:**
```ruby
gem 'active_shipping', '~> 2.0' # or 'activ_shipping'
```

**Why ActiveShipping?**
- Integrates with major carriers (USPS, FedEx, UPS)
- Real-time shipping rate calculations
- Label printing capabilities
- Tracking number management

**Implementation Tasks:**
1. Add active_shipping gem
2. Create `ShippingMethod` model:
   - Store-specific shipping options
   - Carrier, service level
   - Rate calculations
3. Create `Shipment` model:
   - Links to order
   - Tracking number
   - Carrier info
   - Status tracking
4. Integrate rate calculations in checkout
5. Add shipping address validation
6. Create shipping label generation (admin/store owner)

**Note:** ActiveShipping may require API keys for carriers. Consider starting with flat-rate shipping and adding carrier integration later.

**Alternative:** Start with simple flat-rate shipping model:
```ruby
# Store model additions
- shipping_cost (decimal)
- free_shipping_threshold (decimal)
- shipping_zones (serialized hash)
```

---

### Phase 3: Enhanced Features (Weeks 5-6)

#### 3.1 Internationalization (Optional) - **LOW PRIORITY** 🟢

**Gem to Add:**
```ruby
gem 'globalize', '~> 6.0'
gem 'friendly_id-globalize', '~> 0.3'
```

**Why Globalize?**
- Multi-language product descriptions
- Multi-currency support
- Expand to international markets

**Implementation Tasks:**
1. Add translations table migration
2. Configure default locale
3. Add language switcher
4. Translate product/store content

**Recommendation:** Defer this unless you're expanding internationally immediately.

---

#### 3.2 Code Quality - **DEVELOPMENT ONLY** 🟢

**Gem to Add:**
```ruby
group :development do
  gem 'rails_best_practices'
  gem 'brakeman' # Security scanner
  gem 'rubocop' # Code style
end
```

**Implementation:**
- Add to development group
- Run periodically to check code quality
- Not needed for production

---

### Phase 4: Architecture Enhancement (Optional)

#### 4.1 Trailblazer (Advanced)

**Gem to Add:**
```ruby
gem 'trailblazer', '~> 2.1'
```

**When to Consider:**
- If application becomes complex
- Need better code organization
- Multiple developers working on project

**Recommendation:** Defer unless experiencing code organization issues.

---

## Implementation Roadmap

### Immediate Priorities (Next 2 Weeks)
1. ✅ Add Stripe gem
2. ✅ Create Product model and associations
3. ✅ Build shopping cart system
4. ✅ Create Order and OrderItem models
5. ✅ Integrate Stripe checkout
6. ✅ Add payment webhook handling

### Short-term (Weeks 3-4)
1. Add shipping calculations (start with flat-rate)
2. Create shipment tracking
3. Build order management dashboard for store owners
4. Add inventory management

### Medium-term (Weeks 5-6)
1. Add ActiveShipping for carrier rates
2. Implement shipping label printing
3. Add order status notifications (email)
4. Build admin order management

### Long-term (Future)
1. Multi-currency support (if needed)
2. Internationalization (Globalize)
3. Advanced analytics
4. Subscription products (Stripe subscriptions)

---

## Database Migration Strategy

### Step 1: Products
```bash
rails generate migration CreateProducts name:string description:text sku:string price:decimal compare_at_price:decimal inventory_quantity:integer weight:decimal status:string store:references
rails generate migration CreateProductImages product:references image:string
```

### Step 2: Cart & Orders
```bash
rails generate migration CreateCarts user:references store:references
rails generate migration CreateCartItems cart:references product:references quantity:integer
rails generate migration CreateOrders store:references user:references status:string total_amount:decimal currency:string shipping_address:text billing_address:text stripe_payment_intent_id:string
rails generate migration CreateOrderItems order:references product:references quantity:integer unit_price:decimal total_price:decimal
```

### Step 3: Payments & Shipping
```bash
rails generate migration CreatePayments order:references amount:decimal currency:string status:string stripe_charge_id:string
rails generate migration CreateShippingMethods store:references name:string carrier:string service_level:string base_rate:decimal
rails generate migration CreateShipments order:references shipping_method:references tracking_number:string carrier:string status:string
```

---

## Security Considerations

1. **PCI Compliance**
   - Never store credit card data
   - Use Stripe Elements for secure payment collection
   - Store only payment intent IDs

2. **API Keys**
   - Use environment variables (dotenv-rails already installed)
   - Never commit keys to git
   - Use different keys for test/production

3. **Order Security**
   - Validate ownership before order access
   - Use Pundit policies for order authorization
   - Implement CSRF protection (Rails default)

4. **Payment Security**
   - Verify webhook signatures from Stripe
   - Implement idempotency keys for payments
   - Log all payment attempts

---

## Environment Configuration

Add to `.env` (already have dotenv-rails):
```bash
# Stripe
STRIPE_PUBLISHABLE_KEY=pk_test_...
STRIPE_SECRET_KEY=sk_test_...
STRIPE_WEBHOOK_SECRET=whsec_...

# Shipping (when ready)
USPS_API_KEY=your_usps_key
FEDEX_API_KEY=your_fedex_key
FEDEX_PASSWORD=your_fedex_password
```

---

## Testing Strategy

1. **Unit Tests**
   - Product model validations
   - Order calculations
   - Cart operations

2. **Integration Tests**
   - Checkout flow
   - Payment processing
   - Order creation

3. **Stripe Test Mode**
   - Use test cards for development
   - Test webhook handling
   - Test failed payments

---

## Cost Considerations

### Stripe Fees
- 2.9% + $0.30 per successful charge
- No monthly fees
- Free for test mode

### ActiveShipping
- Free gem
- Carrier API costs vary
- USPS: Free API access
- FedEx/UPS: May require account setup

### Infrastructure
- No additional hosting costs
- Ensure SSL certificate (required for Stripe)

---

## Next Steps

1. **Review this strategy** with your team
2. **Prioritize features** based on business needs
3. **Start with Phase 1** - Payment processing is critical
4. **Set up Stripe account** in test mode
5. **Create Product model** first (foundation for everything)

---

## References

- [Stripe Rails Gem Documentation](https://stripe.com/docs/stripe-js)
- [ActiveMerchant Documentation](https://github.com/activemerchant/active_merchant)
- [ActiveShipping GitHub](https://github.com/Shopify/active_shipping)
- [Resolve Digital Article](https://www.resolvedigital.com/blog/8-best-ruby-on-rails-gems-for-ecommerce-applications)

---

## Questions to Consider

1. **Payment Methods**: Stripe only, or need PayPal/Square?
2. **Shipping**: Start with flat-rate or carrier integration?
3. **Physical vs Digital**: Will stores sell digital products?
4. **Tax Calculation**: Need automatic tax calculation?
5. **Multi-currency**: Immediate need or future?
6. **Subscription Products**: One-time purchases only or subscriptions?

---

**Recommended First Action:** Add Stripe gem and create Product model. This provides the foundation for all e-commerce functionality.

