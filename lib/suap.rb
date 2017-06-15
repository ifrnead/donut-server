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
      response = RestClient.get("https://suap.ifrn.edu.br/api/v2/minhas-informacoes/meus-dados/",
        {
          'Content-Type': 'application/json',
          'Authorization': "JWT #{token}"
        }
      )
      return JSON.parse(response.body)
    end

    def self.fetch_rooms_data(token)
      "[
        { \"id\": 22121,
          \"ano_letivo\": 65,
          \"periodo_letivo\": 1,
          \"componente_curricular\": \"TSUB.0506 - Fundamentos de Lógica e Algoritmos(30H) - Médio [30 h/40 Aulas] \",
          \"data_inicio\": \"2017-03-23\",
          \"data_fim\": \"2017-08-02\"
        },
        { \"id\": 22122,
          \"ano_letivo\": 65,
          \"periodo_letivo\": 1,
          \"componente_curricular\": \"TSUB.0506 - Programação Estruturada e Orientada a Objetos (30H) - Médio [30 h/40 Aulas] \",
          \"data_inicio\": \"2017-03-23\",
          \"data_fim\": \"2017-08-02\"
        },
        { \"id\": 22123,
          \"ano_letivo\": 65,
          \"periodo_letivo\": 1,
          \"componente_curricular\": \"TSUB.0506 - Programação de Sistemas para Internet (30H) - Médio [30 h/40 Aulas] \",
          \"data_inicio\": \"2017-03-23\",
          \"data_fim\": \"2017-08-02\"
        },
        { \"id\": 22124,
          \"ano_letivo\": 65,
          \"periodo_letivo\": 1,
          \"componente_curricular\": \"TSUB.0506 - Projeto de Desenvolvimento de Software (30H) - Médio [30 h/40 Aulas] \",
          \"data_inicio\": \"2017-03-23\",
          \"data_fim\": \"2017-08-02\"
        }
      ]"
    end
  end

end
