class CheckoutController < ApplicationController

    def create
        @product = Product.find(checkout_params[:id])

        if @product.nil?
            redirect_to root_path
        end
        if @product.price < 1
            amount = 1.0
        else 
            amount = @product.price
        end

        @session = Stripe::Checkout::Session.create({
            payment_method_types: ['card'],
            line_items: [{
            price_data: {
                unit_amount: amount.to_i * 100,
                currency: 'usd',
                product_data: {
                name: @product.name,
                images: ['https://i.imgur.com/EHyR2nP.png'],
                },
            },
            quantity: 1,
            }],
            mode: 'payment',
            success_url: checkout_success_url + '?session_id={CHECKOUT_SESSION_ID}',
            cancel_url: checkout_cancel_url
        })

        {
            id: session.id
        }.to_json

        respond_to do |format|
            format.js #render create.js.erb
        end

    end

    def success
        @session = Stripe::Checkout::Session.retrieve(params[:session_id])
        @payment_intent = Stripe::PaymentIntent.retrieve(@session.payment_intent)
    end

    def cancel

    end

    private

    def checkout_params
        params.permit(:id)
    end


end
