require 'errors'

module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from DonutServer::Errors::InvalidCredentialsError do |e|
      json_response({ message: e.message }, :unauthorized)
    end

    rescue_from DonutServer::Errors::InvalidTokenError do |e|
      json_response({ message: e.message }, :unauthorized)
    end
  end
end
