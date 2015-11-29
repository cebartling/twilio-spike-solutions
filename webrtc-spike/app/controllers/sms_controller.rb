require 'twilio-ruby'

class SmsController < ApplicationController

  def index
    # To find these visit https://www.twilio.com/user/account
    # account_sid = 'ACXXXXXXXXXXXXXXXXX'
    # auth_token = 'YYYYYYYYYYYYYYYYYY'

    begin
      @client = Twilio::REST::Client.new Rails.configuration.twilio_account_sid, Rails.configuration.twilio_auth_token
      @client.account.messages.create({
                                        from: '+19525134351',
                                        to: '+16129646238',
                                        body: 'Hello from Twilio!'
                                      })
    rescue Twilio::REST::RequestError => e
      puts e.message
    end
  end

end
