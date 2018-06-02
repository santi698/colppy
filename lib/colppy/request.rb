# frozen_string_literal: true

require_relative 'types'
require 'dry-struct'

class Colppy
  class Request < Dry::Struct
    attribute :auth do
      attribute :usuario, Types::Email
      attribute :password, Types::Strict::String
    end
    attribute :service do
      attribute :provision, Types::Provision
      attribute :operacion, Types::Operation
    end
    attribute :parameters, Types::Parameters

    def to_json
      to_h.to_json
    end
  end
end
