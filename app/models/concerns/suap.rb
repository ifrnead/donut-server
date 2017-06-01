module SUAP
  module API extend ActiveSupport::Concern
    require 'rest-client'

    class_methods do
      def authenticate(username:, password:)
        response = RestClient.post('https://suap.ifrn.edu.br/api/v2/autenticacao/token/',
          { "username": username, "password": password }.to_json,
          { content_type: :json, accept: :json }
        )
        if response.code.to_i == 200
          return JSON.parse(response.body)["token"]
        end
        return response.code
      end

      def fetch_user_data(token)
        response = RestClient.get("https://suap.ifrn.edu.br/api/v2/minhas-informacoes/meus-dados/",
          {
            'Content-Type': 'application/json',
            'Authorization': "JWT #{token}"
          }
        )
        if response.code.to_i == 200
          return JSON.parse(response.body)
        end
        return response.code
      end
    end

  end
end
