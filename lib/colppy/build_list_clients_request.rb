# frozen_string_literal: true

require_relative 'types'

module Colppy
  class BuildListClientsRequest
    def self.call(limit:, offset:, filter:, order:, company_id:)
      {
        service: { provision: 'Cliente', operacion: 'listar_cliente' },
        parameters: {
          limit: offset + limit,
          start: offset,
          filter: Types::Strict::Array.of(Filter)[filter],
          order: Types::Strict::Array.of(Order)[order],
          idEmpresa: company_id
        }
      }
    end
  end
end
