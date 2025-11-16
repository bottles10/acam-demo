require 'net/http'
require 'uri'
require 'json'

class PaymentsController < ApplicationController
  def new
  end

  def create
  email = params[:email]
  tier = PriceTier.find(params[:tier_id])

  amount = tier.price * 100   # convert to pesewas
  reference = SecureRandom.hex(10)

  payment = Payment.create!(
    email: email,
    amount: amount,
    reference: reference,
    status: "pending"
  )

  uri = URI("https://api.paystack.co/transaction/initialize")
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true

  request = Net::HTTP::Post.new(uri.path)
  request["Authorization"] = "Bearer #{paystack_secret_key}"
  request["Content-Type"] = "application/json"
  request.body = {
    email: email,
    amount: amount,
    callback_url: payments_callback_url,
    reference: reference
  }.to_json

  response = http.request(request)
  data = JSON.parse(response.body)

  if data["status"]
    redirect_to data["data"]["authorization_url"], allow_other_host: true
  else
    redirect_to payments_error_path, alert: "Error initializing payment"
  end
end


 def callback
  reference = params[:reference]
  uri = URI("https://api.paystack.co/transaction/verify/#{reference}")
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true

  request = Net::HTTP::Get.new(uri.path)
  request["Authorization"] = "Bearer #{paystack_secret_key}"

  response = http.request(request)
  data = JSON.parse(response.body)

  payment = Payment.find_by(reference:)

  if data["status"] && data["data"]["status"] == "success"
    license = payment.generate_license_key

    payment.update(
      status: "success",
      license_key: license
    )

    redirect_to payments_success_path(reference: payment.reference)
  else
    payment.update(status: "failed")
    redirect_to payments_error_path
  end
end


  def success
     @payment = Payment.find_by(reference: params[:reference])
  end

  def error
  end

  private

  def paystack_secret_key
    Rails.application.credentials[:PAYSTACK_SECRET_KEY]
  end
end

