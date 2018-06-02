# frozen_string_literal: true

require 'dry-types'

class Colppy
  module Types
    include Dry::Types.module
    Provision = Types::Strict::String.enum('Cliente', 'Usuario', 'FacturaVenta')
    Operation = Types::Strict::String
    Parameters = Types::Hash
    Email = Types::Strict::String.constrained(
      format: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
    )
    Filter = Types::Hash.schema(
      field: Types::Strict::String,
      op: Types::Strict::String.enum('='),
      value: Types::Strict::String
    )
    Order = Types::Hash.schema(
      field: Types::Strict::String,
      dir: Types::Strict::String.enum('asc', 'desc', 'ASC', 'DESC')
    )
  end
end
