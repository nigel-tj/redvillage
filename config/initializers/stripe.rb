# Avoid crashing boot when Stripe keys are unset (common on first Fly deploy).
Stripe.api_key = ENV["STRIPE_SECRET_KEY"].presence

Rails.configuration.stripe = {
  publishable_key: ENV["STRIPE_PUBLISHABLE_KEY"].presence,
  secret_key: ENV["STRIPE_SECRET_KEY"].presence
}
