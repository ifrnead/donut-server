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

    rescue_from DonutServer::Errors::RecordNotFound do |e|
      json_response({ message: e.message }, :not_found)
    end

    rescue_from ActionController::RoutingError do |e|
      json_response({ message: e.message }, :not_found)
    end
  end
end
