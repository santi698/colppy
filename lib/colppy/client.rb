# frozen_string_literal: true

require 'httparty'
require_relative 'request'
require_relative 'build_login_request'
require_relative 'configuration'
require_relative 'build_find_client_request'
require_relative 'build_list_bills_request'
require_relative 'build_list_clients_request'

module Colppy
  class Client
    class BadRequestError < StandardError; end
    class LoginError < StandardError; end

    include HTTParty

    DEFAULT_TIMEOUT = 120

    def initialize
      self.class.base_uri Configuration.config.service_url
    end

    def login(
      user_email: Configuration.config.user_email,
      user_password: Configuration.config.user_password
    )
      Colppy.log('info', 'Logging in to Colppy')
      request = Colppy::Request.new(
        **BuildLoginRequest.call(
          user_email: user_email,
          user_password: user_password
        ).merge(auth: auth)
      )
      session_key = make_request(request)['claveSesion']
      Colppy.log('info', 'Colppy Log in successful')
      @session = { usuario: user_email, claveSesion: session_key }
    end

    def find_client(client_id, company_id: Configuration.config.company_id)
      find_client_request = BuildFindClientRequest.call(client_id: client_id, company_id: company_id)
      request = Colppy::Request.new(**encapsulate_request(find_client_request))
      make_request(request)
    end

    def list_clients(
      filter: [],
      order: [{ field: 'RazonSocial', dir: 'ASC' }],
      limit: 15,
      offset: 0,
      company_id: Configuration.config.company_id
    )
      list_clients_request = Colppy::BuildListClientsRequest.call(
        filter: filter, order: order, limit: limit, offset: offset,
        company_id: company_id
      ).to_h
      request = Colppy::Request.new(**encapsulate_request(list_clients_request))
      make_request(request)
    end

    def find_clients_by(**hash)
      filter = hash.map { |k, v| { field: k.to_s, op: '=', value: v.to_s } }
      list_clients(filter: filter)
    end

    def list_bills(filter: [], company_id: Configuration.config.company_id, offset: 0, limit: 1000)
      list_bills_request = Colppy::BuildListBillsRequest.call(
        filter: filter, limit: limit, offset: offset,
        company_id: company_id
      ).to_h
      request = Colppy::Request.new(**encapsulate_request(list_bills_request))
      make_request(request)
    end

    def find_bills_by_date(date)
      list_bills(filter: [{ field: 'fechaFactura', op: '=', value: date.strftime('%Y-%m-%d') }])
    end

    private

    def encapsulate_request(request)
      encapsulated_request = request.dup
      encapsulated_request[:parameters][:sesion] = @session
      encapsulated_request[:auth] = auth
      encapsulated_request
    end

    def make_request(request)
      Colppy.log('debug', "Making colppy request: #{request.to_json}")
      @response = self.class.post(
        '/', body: request.to_json, verify: production_environment?, timeout: DEFAULT_TIMEOUT
      )
      parsed_response = @response.parsed_response
      if parsed_response.nil?
        Colppy.log('error', "Error in colppy request. Response: #{@response}")
        raise BadRequestError
      end
      response = parsed_response['response']
      raise LoginError if response.nil?
      response['data']
    end

    def production_environment?
      Configuration.config.service_url =~ /https/
    end

    def auth
      @auth ||= {
        usuario: Configuration.config.dev_user_email,
        password: Digest::MD5.hexdigest(Configuration.config.dev_user_password)
      }
    end
  end
end
