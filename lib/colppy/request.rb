# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module Types
  include Dry::Types.module
end

module Colppy
  class Request < Dry::Struct
    Provision = Types::Strict::String.enum('Cliente', 'Usuario', 'FacturaVenta')
    Operation = Types::Strict::String
    Parameters = Types::Hash
    Email = Types::Strict::String.constrained(
      format: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
    )

    attribute :auth do
      attribute :usuario, Email
      attribute :password, Types::Strict::String
    end
    attribute :service do
      attribute :provision, Provision
      attribute :operacion, Operation
    end
    attribute :parameters, Parameters

    def to_json
      to_h.to_json
    end
  end
end
