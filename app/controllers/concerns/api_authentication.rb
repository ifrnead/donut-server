require 'errors'

module APIAuthentication
  def token_required
    return auth_token || unauthorized
  end

  def auth_token
    authenticate_or_request_with_http_token do |token, options|
      if User.find_by_token(token)
        return true
      end
      return false
    end
  end

  def unauthorized
    self.headers['WWW-Authenticate'] = 'Token realm="Application"'
    raise DonutServer::Errors::InvalidTokenError.new
  end

  def current_user
    http_authorization = request.headers["HTTP_AUTHORIZATION"]
    token = http_authorization[6, http_authorization.size]
    User.find_by_token(token)
  end
end
