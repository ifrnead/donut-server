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

    def self.fetch_rooms_data_by_student(token:, year:, semester:)
      rooms = Array.new
      response = RestClient.get("https://suap.ifrn.edu.br/api/v2/minhas-informacoes/turmas-virtuais/#{year}/#{semester}/", headers(token))
      rooms_data = JSON.parse(response.body)
      rooms_data.each do |room_data|
        room = Room.find_by_suap_id(room_data["id"])
        if room.nil?
          room = Room.create(
            suap_id: room_data["id"],
            year: 2017,
            semester: 1,
            curricular_component: "#{room_data['sigla']} - #{room_data['descricao']}",
            title: room_data["descricao"]
          )
        end
        rooms << room
      end
      rooms << Room.playground if ENV['PLAYGROUND']
      rooms
    end

    def self.fetch_rooms_data_by_professor(token:, year:, semester:)
      rooms = Array.new
      response = RestClient.get("https://suap.ifrn.edu.br/api/v2/minhas-informacoes/meus-diarios/#{year}/#{semester}/", headers(token))
      rooms_data = JSON.parse(response.body)
      rooms_data.each do |room_data|
        room = Room.find_by_suap_id(room_data["id"])
        if room.nil?
          room = Room.create(
            suap_id: room_data["id"],
            year: room_data["ano_letivo"],
            semester: room_data["periodo_letivo"],
            curricular_component: room_data["componente_curricular"],
            title: room_data["componente_curricular"].split(" - ")[1]
          )
        end
        rooms << room
      end
      rooms << Room.playground if ENV['PLAYGROUND']
      rooms
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
