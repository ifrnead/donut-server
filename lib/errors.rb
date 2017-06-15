module DonutServer

  module Errors
    class InvalidCredentialsError < StandardError
      def initialize(msg = "invalid_credentials")
        super(msg)
      end
    end

    class InvalidTokenError < StandardError
      def initialize(msg = "invalid_token")
        super(msg)
      end
    end
  end

end
