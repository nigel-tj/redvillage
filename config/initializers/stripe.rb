Stripe.api_key = ENV['STRIPE_SECRET_KEY'] || 'sk_test_your_key_here'

Rails.configuration.stripe = {
  publishable_key: ENV['STRIPE_PUBLISHABLE_KEY'] || 'pk_test_your_key_here',
  secret_key: ENV['STRIPE_SECRET_KEY'] || 'sk_test_your_key_here'
}

