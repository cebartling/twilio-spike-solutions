class TwilioController < ApplicationController

  respond_to :html, :json

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

  def service_token
    twilio_client = Twilio::REST::Client.new Rails.configuration.twilio_account_sid,
                                             Rails.configuration.twilio_auth_token
    network_traversal_service_token = twilio_client.account.tokens.create
    if network_traversal_service_token
      result = {
        tokenUsername: network_traversal_service_token.username,
        tokenPassword: network_traversal_service_token.password,
        timeToLive: network_traversal_service_token.ttl,
        accountSid: network_traversal_service_token.account_sid,
        dateCreated: network_traversal_service_token.date_created,
        dateUpdated: network_traversal_service_token.date_updated,
        iceServers: network_traversal_service_token.ice_servers
      }
      respond_to do |format|
        format.json { render json: result }
      end
    end
  end

  def capability_token
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

    respond_to do |format|
      format.json { render json: {token: @token} }
    end
  end

  def voice
    number = params[:PhoneNumber]
    unless number
      number = Rails.configuration.default_client
    end
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
