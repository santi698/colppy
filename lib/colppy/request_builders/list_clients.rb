# frozen_string_literal: true

require_relative '../types'

class Colppy
  module RequestBuilders
    class ListClients
      def self.call(limit:, offset:, filter:, order:, company_id:)
        {
          service: { provision: 'Cliente', operacion: 'listar_cliente' },
          parameters: {
            limit: offset + limit,
            start: offset,
            filter: Types::Strict::Array.of(Types::Filter)[filter],
            order: Types::Strict::Array.of(Types::Order)[order],
            idEmpresa: company_id
          }
        }
      end
    end
  end
end
