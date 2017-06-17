require 'rest-client'

module SUAP
  class API

    def self.authenticate(username:, password:)
      response = RestClient.post('https://suap.ifrn.edu.br/api/v2/autenticacao/token/',
        { "username": username, "password": password }.to_json,
        { content_type: :json, accept: :json }
        )
      return JSON.parse(response.body)["token"]
    end

    def self.fetch_user_data(token)
      response = RestClient.get("https://suap.ifrn.edu.br/api/v2/minhas-informacoes/meus-dados/", headers(token))
      return JSON.parse(response.body)
    end

    def self.fetch_rooms_data(token:, year:, semester:)
      response = RestClient.get("https://suap.ifrn.edu.br/api/v2/minhas-informacoes/meus-diarios/#{year}/#{semester}/", headers(token))
      return JSON.parse(response.body)
    end

    private

    def self.headers(token)
      {
        'Content-Type': 'application/json',
        'Authorization': "JWT #{token}"
      }
    end
  end
end
