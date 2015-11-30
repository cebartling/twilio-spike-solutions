class TwilioController < ApplicationController

  protect_from_forgery with: :null_session

  def index
    @client_name = params[:client]
    if @client_name.nil?
      @client_name = Rails.configuration.default_client
    end

    # Find these values at twilio.com/user/account
    capability = Twilio::Util::Capability.new Rails.configuration.twilio_account_sid,
                                              Rails.configuration.twilio_auth_token
    capability.allow_client_incoming @client_name
    capability.allow_client_outgoing Rails.configuration.twilio_twiml_app_sid
    @token = capability.generate
  end

  def voice
    number = params[:PhoneNumber]
    response = Twilio::TwiML::Response.new do |r|
      # Should be your Twilio Number or a verified Caller ID
      r.Dial callerId: Rails.configuration.twilio_registered_phone_number do |d|
        if /^[\d\+\-\(\) ]+$/.match(number)
          d.Number(CGI::escapeHTML number)
        else
          d.Client number
        end
      end
    end
    render text: response.text
  end

end
