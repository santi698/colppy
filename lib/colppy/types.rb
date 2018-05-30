# frozen_string_literal: true

require 'dry-types'

module Types
  include Dry::Types.module
end

module Colppy
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
