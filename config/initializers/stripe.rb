Rails.configuration.strip = {
    publishable_key: ENV['STRIPE_PUBLISHABLE_KEY'],
    secret_key: ENV['SECRET_KEY']
}
Stripe.api_key = ENV['SECRET_KEY']
