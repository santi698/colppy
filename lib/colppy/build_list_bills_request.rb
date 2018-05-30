# frozen_string_literal: true

require_relative 'types'

module Colppy
  class BuildListBillsRequest
    def self.call(limit:, offset:, filter:, company_id:)
      {
        service: { provision: 'FacturaVenta', operacion: 'listar_facturasventa' },
        parameters: {
          limit: offset + limit,
          start: offset,
          filter: Types::Strict::Array.of(Filter)[filter],
          idEmpresa: company_id
        }
      }
    end
  end
end
