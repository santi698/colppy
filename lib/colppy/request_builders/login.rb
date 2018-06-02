# frozen_string_literal: true

class Colppy
  module RequestBuilders
    class Login
      def self.call(user_email:, user_password:)
        {
          service: { provision: 'Usuario', operacion: 'iniciar_sesion' },
          parameters: {
            usuario: user_email,
            password: Digest::MD5.hexdigest(user_password)
          }
        }
      end
    end
  end
end
