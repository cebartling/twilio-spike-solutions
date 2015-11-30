class TwilioController < ApplicationController

  # respond_to :json

  def index
    # Find these values at twilio.com/user/account
    capability = Twilio::Util::Capability.new Rails.configuration.twilio_account_sid,
                                              Rails.configuration.twilio_auth_token
    capability.allow_client_outgoing Rails.configuration.twilio_twiml_app_sid
    capability.allow_client_incoming 'chris'
    @token = capability.generate
    # respond_to do |format|
    #   format.json { render json: {token: @token} }
    # end
  end

  def voice
    response = Twilio::TwiML::Response.new do |r|
      # Should be your Twilio Number or a verified Caller ID
      r.Dial callerId: Rails.configuration.twilio_registered_phone_number do |d|
        d.Client 'chris'
      end
    end
    # respond_to do |format|
    #   format.xml { render xml: response.text }
    # end
    render text: response.text
  end

end
