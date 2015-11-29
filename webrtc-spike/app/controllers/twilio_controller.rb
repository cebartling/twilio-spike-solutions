class TwilioController < ApplicationController

  respond_to :json

  def create_capability_token
    # Find these values at twilio.com/user/account
    capability = Twilio::Util::Capability.new Rails.configuration.twilio_account_sid,
                                              Rails.configuration.twilio_auth_token
    capability.allow_client_outgoing Rails.configuration.twilio_twiml_app_sid
    capability.allow_client_incoming 'chris'
    @token = capability.generate
    respond_to do |format|
      format.json { render json: {token: @token} }
    end
  end

end
