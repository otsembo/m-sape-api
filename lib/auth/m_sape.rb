# frozen_string_literal: true

module MSape
  module  Authentication
    JWT_ALGO = 'HS256'
    def jwt_encode(payload:)
      data = { data: payload, exp: Time.now.to_i * 4 * 3600 }
      JWT.encode payload, secret, JWT_ALGO
    end
    def jwt_decode(token:)
      JWT.decode(token, secret, true, { algorithm: JWT_ALGO})
    end

    private
    def secret
      ENV['JWT_SECRET']
    end
  end
end
