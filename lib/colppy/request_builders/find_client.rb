# frozen_string_literal: true

class Colppy
  module RequestBuilders
    class FindClient
      def self.call(client_id:, company_id:)
        {
          service: { provision: 'Cliente', operacion: 'leer_cliente' },
          parameters: {
            idCliente: client_id,
            idEmpresa: company_id
          }
        }
      end
    end
  end
end
