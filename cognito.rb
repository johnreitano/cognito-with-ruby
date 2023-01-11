# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'
Bundler.require

require 'dotenv/load'

# holds cognito-related static methods
class Cognito
  @client = Aws::CognitoIdentityProvider::Client.new(region: ENV['AWS_REGION'])

  def self.authenticate(user_object)
    puts "ENV['AWS_COGNITO_APP_CLIENT_ID']=|#{ENV['AWS_COGNITO_APP_CLIENT_ID']}|"
    auth_object = {
      client_id: ENV['AWS_COGNITO_APP_CLIENT_ID'],
      auth_flow: 'USER_PASSWORD_AUTH',
      auth_parameters: user_object
    }
    @client.initiate_auth(auth_object)
  end

  def self.sign_out(access_token)
    @client.global_sign_out(access_token: access_token)
  end

  def self.create_user(user_object)
    auth_object = {
      client_id: ENV['AWS_COGNITO_APP_CLIENT_ID'],
      username: user_object[:USERNAME],
      password: user_object[:PASSWORD]
    }
    @client.sign_up(auth_object)
  end
end

results = Cognito.create_user({ USERNAME: 'rubytest4@mmhmmtest.app', PASSWORD: 'Password123*' })
puts "create_user results=#{results}"

results = Cognito.authenticate({ USERNAME: 'rubytest4@mmhmmtest.app', PASSWORD: 'Password123*' })
puts "authenticate results=#{results}"
