# frozen_string_literal: true

class  Authentication
  JWT_ALGO = 'HS256'
  def jwt_encode(payload:)
    data = { data: payload, exp: Time.now.to_i * 4 * 3600 }
    JWT.encode data, secret, JWT_ALGO
    rescue JWT::EncodeError =>  _e
      nil
  end
  def jwt_decode(token:)
    JWT.decode(token, secret, true, { algorithm: JWT_ALGO})
    rescue JWT::DecodeError => e
      nil
  end

  private
  def secret
    ENV['JWT_SECRET']
  end
end
