# Server-side code for Braintree payments

# Requiring some gems, yo!
require "rubygems"
require "sinatra"
require "braintree"

# Braintree API keys
Braintree::Configuration.environment = :sandbox
Braintree::Configuration.merchant_id = "2xt7pzvycxmfq4qd"
Braintree::Configuration.public_key = "z274y2xkjhnrwmh7"
Braintree::Configuration.private_key = "cbae90c119dcea47fa226ab6f3758684"

# Set up the route for the payment form created in next step
get "/" do
  erb :braintree
end

# Payment form will POST to create_transaction
post "/create_transaction" do
  # Use Braintree client library to create transaction using encrypted params from payment form
  result = Braintree::Transaction.sale(
    # Hardcoded :amount
    :amount => "1000.00",
    :credit_card => {
      :number => params[:number],
      :cvv => params[:cvv],
      :expiration_month => params[:month],
      :expiration_year => params[:year]
    },
    :options => {
      # Funds automatically debited from customer credit card on trxn creation
      :submit_for_settlement => true
    }
  )

  # Return a formatted response of result
  if result.success?
    "<h1>Success! Transaction ID: #{result.transaction.id}</h1>"
  else
   "<h1>Error: #{result.message}</h1>"
  end
end   